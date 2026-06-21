# Динамическое содержимое Cloud-Init с помощью Terraform File Templates

> **Автор:** Grant Orchard  
> **Оригинал:** [grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/](https://grantorchard.com/dynamic-cloudinit-content-with-terraform-file-templates/)  
> **Дата публикации:** 2020-01-07

---

В [предыдущей статье](https://grantorchard.com/terraform-vsphere-cloud-init/) мы рассмотрели, как использовать cloud-init для обеспечения согласованного рабочего процесса инициализации образов как в публичных, так и в частных облаках. В простом примере мы передавали набор жёстко заданных значений в виртуальную машину на vSphere, что не отражает реальных операций, необходимых в production-среде. В этой статье мы приблизимся к реальному сценарию и рассмотрим, как использовать ресурс Terraform [`template_file`](https://www.terraform.io/docs/providers/template/d/file.html) для подстановки переменных и условного включения блоков в файлы userdata и metadata cloud-init.

## Код

Прежде чем мы начнём, вы можете следить за кодом в [моём репозитории](https://github.com/grantorchard/terraform-vsphere-cloudinit-dynamic).

По сравнению с предыдущим примером, я добавил файл **config.tf**, который будет использоваться для обработки рендеринга шаблонов. Выносить это в отдельный файл не обязательно, но мне так проще функционально разделять код Terraform, особенно когда нужно объяснить написанное другим людям. Также в файле **outputs.tf** появился код, упрощающий проверку корректности рендеринга файлов.

## Интерполяция переменных

Для начала давайте посмотрим на подстановку переменных в наш файл userdata.
Быстрый взгляд на **config.tf** показывает следующий блок:

```hcl
data template_file "userdata" {
  template = file("${path.module}/templates/userdata.yaml")

  vars = {
    username           = var.username
    ssh_public_key     = file(var.ssh_public_key)
    packages           = jsonencode(var.packages)
  }
}
```

Разберём, из чего состоит этот ресурс.

**template** — путь к файлу шаблона, который мы хотим обработать.
**vars** — пары «ключ/значение», которые будут подставлены в процессе рендеринга.

Полезный момент, на который стоит обратить внимание — использование **jsonencode** для преобразования типов HCL в формат, понятный cloud-init. Кодирование значения позволяет передать список, тогда как в обычных условиях ресурс template_file поддерживает только строки.
Возможно, вы спросите, почему мы не используем yamlencode, ведь мы работаем с YAML-файлами. Дело в том, что YAML чувствителен к пробелам, что сложно обработать. Кроме того, YAML поддерживает некоторые простые JSON-конструкции, например списки строк — именно то, что нам нужно.

Теперь давайте посмотрим на **userdata.yaml** в директории templates.

```yaml
#cloud-config
users:
  - name: ${username}
    ssh-authorized-keys:
      - ${ssh_public_key}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    groups: sudo
    shell: /bin/bash

packages: ${packages}
```

Места подстановки переменных обозначены синтаксисом интерполяции `${value}`.

Пока всё хорошо! Переходим на следующий уровень.

## Условный рендеринг

Все эти готовые конфигурационные файлы замечательны, но давайте на минуту задумаемся о реальном мире. Простой, но распространённый пример, о котором меня спросил [Anthony Spiteri](https://twitter.com/anthonyspiteri) — как обрабатывать назначение IP через DHCP vs статический IP без необходимости создавать два отдельных набора кода Terraform.

Разве не здорово было бы использовать какое-то условие для включения или исключения определённых блоков кода?

Откройте **metadata.yaml** в директории templates и посмотрите, как это можно сделать.

```yaml
local-hostname: ${hostname}
instance-id: ${hostname}
network:
  version: 2
  ethernets:
    ens192:
      %{ if dhcp == "true" }dhcp4: true
      %{ else }addresses:
        - ${ip_address}/${netmask}
      gateway4: ${gateway}
      nameservers:
        addresses: ${nameservers}
      %{ endif }
```

Ключевые элементы здесь — конструкции `%{ условия }`. Что мы говорим? Если переменная `dhcp` равна `true`, то включаем блок `dhcp4: true`. В противном случае — включаем последующий код для настройки статического IP. Удобно, правда?

Вернёмся к файлу **config.tf** и посмотрим на ресурс `template_file.metadata`.

```hcl
data template_file "metadata" {
  template = file("${path.module}/templates/metadata.yaml")
  vars = {
    dhcp        = var.dhcp
    hostname    = var.hostname_prefix
    ip_address  = var.ip_address
    netmask     = var.netmask
    nameservers = jsonencode(var.nameservers)
    gateway     = var.gateway
  }
}
```

Обратите внимание, что первая переменная, которую он хочет получить — `var.dhcp`. Это значение задаётся в вашем файле **terraform.tfvars**.
Важный момент: при ссылке на переменные они не могут иметь значение null. Чтобы код был DRY (don't repeat yourself) и все переменные оставались на месте независимо от того, используем мы DHCP или статическую адресацию, мы задаём пустые значения по умолчанию для всех этих переменных в файле **variables.tf**. Ниже приведены пара примеров:

```hcl
variable gateway {
  type    = string
  default = ""
}

variable nameservers {
  type    = list
  default = []
}
```

## Валидация кода

Полезный трюк, который я применяю при работе с источником данных template_file — начать только с файла **config.tf** и шаблонов. Я создаю файл **outputs.tf**, выполняю `terraform apply` и проверяю, что вывод рендерится так, как нужно. После этого я добавляю остальные ресурсы, например виртуальные машины.

```hcl
output metadata {
  value = "\n${data.template_file.metadata.rendered}"
}

output userdata {
  value = "\n${data.template_file.userdata.rendered}"
}
```

Примечание: `\n` — это символ новой строки, позволяющий увидеть значение вывода, начиная с новой строки, как показано на изображении ниже.

![Вывод metadata и userdata](../assets/images/2020/cloudinit-dynamic/output.png)

## Применение кода

Файл `terraform.tfvars.example` содержит отправную точку для переменных, которые необходимо задать в вашем окружении. Вы можете установить значение `*dhcp` в `"true"` или `"false"`, выполнить `terraform plan` и `terraform apply` как обычно — и всё готово.

## Заключение

Переменные можно использовать для рендеринга динамических полей и даже условного включения блоков или содержимого других файлов. Использование этой возможности значительно повышает переиспользование кода. В следующей статье мы объединим то, что показали в двух последних постах, и начнём развёртывание продуктов Hashicorp на vSphere.