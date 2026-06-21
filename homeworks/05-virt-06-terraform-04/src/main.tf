#создаем облачную сеть
resource "yandex_vpc_network" "develop" {
  name = var.network_name
}

#создаем подсеть
resource "yandex_vpc_subnet" "develop_a" {
  name           = "${var.network_name}-a-${var.zone}"
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet_a_cidr
}

resource "yandex_vpc_subnet" "develop_b" {
  name           = "${var.network_name}-b-${var.zone}"
  zone           = var.zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.subnet_b_cidr
}


module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "marketing"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.zone]
  subnet_ids     = [yandex_vpc_subnet.develop_a.id, yandex_vpc_subnet.develop_b.id]
  instance_name  = "web"
  public_ip      = var.public_ip
  platform       = var.platform_id

  labels = {
    project = "marketing"
  }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

}

module "analytics_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "analytics"
  network_id     = yandex_vpc_network.develop.id
  subnet_zones   = [var.zone]
  subnet_ids     = [yandex_vpc_subnet.develop_b.id]
  instance_name  = "web"
  public_ip      = var.public_ip
  platform       = var.platform_id

  metadata = {
    user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
    serial-port-enable = 1
  }

  labels = {
    project = "analytics"
  }
}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
  vars = {
    ssh_public_key   = var.public_key
    username         = var.vm_username
    package_update   = var.package_update
    package_upgrade  = var.package_upgrade
    packages         = jsonencode(var.packages)
  }
}
