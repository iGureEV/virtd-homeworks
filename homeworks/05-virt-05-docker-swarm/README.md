# Домашнее задание к занятию 6. «Оркестрация кластером Docker контейнеров на примере Docker Swarm»

#### Это задание для самостоятельной отработки навыков и не предполагает обратной связи от преподавателя. Его выполнение не влияет на завершение модуля. Но мы рекомендуем его выполнить, чтобы закрепить полученные знания. Все вопросы, возникающие в процессе выполнения заданий, пишите в раздел "Вопросы по заданиям" в личном кабинете.

---

## Важно

**Перед началом работы над заданием изучите [Инструкцию по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**
Перед отправкой работы на проверку удаляйте неиспользуемые ресурсы.
Это нужно, чтобы не расходовать средства, полученные в результате использования промокода.
Подробные рекомендации [здесь](https://github.com/netology-code/virt-homeworks/blob/virt-11/r/README.md).

[Ссылки для установки открытого ПО](https://github.com/netology-code/devops-materials/blob/master/README.md).

---

## Задача 1

Создайте ваш первый Docker Swarm-кластер в Яндекс Облаке.
Документация swarm: https://docs.docker.com/engine/reference/commandline/swarm_init/
1. Создайте 3 облачные виртуальные машины в одной сети.
2. Установите docker на каждую ВМ.
3. Создайте swarm-кластер из 1 мастера и 2-х рабочих нод.

4. Проверьте список нод командой:
```
docker node ls
```

Выполнение:
1) Создано 3 облачные виртуальные машины в одной сети.
2) Установлен docker на каждую ВМ:
```sh
➜ sudo apt update && sudo apt upgrade -y
➜ sudo apt install docker.io -y
➜ sudo systemctl start docker
➜ sudo systemctl enable docker
➜ sudo usermod -aG docker $USER
➜ newgrp docker
```
3) Создан swarm-кластер из 1 мастера:
```sh
➜ docker swarm init --advertise-addr 10.130.0.26
Swarm initialized: current node (abc123...) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-xxxxxxxxx-xxxxxxxxxx 10.130.0.26:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow instructions.
```
4) Созданы 2-ва рабочих ноды:
```sh
➜ docker swarm join --token SWMTKN-1-xxxxxxxxx-xxxxxxxxxx 10.130.0.26:2377
```
5) Проверка кластера (кластер помечен звёздочкой):
```sh
docker node ls
```

---

## Задача 2 (*) (необязательное задание *).
1.  Задеплойте ваш python-fork из предыдущего ДЗ(05-virt-04-docker-in-practice) в получившийся кластер.
2. Удалите стенд.

---

## Задача 3 (*)

Если вы уже знакомы с terraform и ansible  - повторите практику по примеру лекции "Развертывание стека микросервисов в Docker Swarm кластере". Попробуйте улучшить пайплайн, запустив ansible через terraform с динамическим инвентарем.

Проверьте доступность grafana.

Иначе вернитесь к выполнению задания после прохождения модулей "terraform" и "ansible".
