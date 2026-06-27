module "s3_bucket" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-s3"

  bucket_name = "terraform-state-netology"
  max_size    = 1073741824  # 1 ГБ
  acl         = "private"

  versioning = {
    enabled = true
  }
}

# Сеть (VPC)

resource "yandex_vpc_network" "this" {
  name = "diplom-network"
}

resource "yandex_vpc_subnet" "this" {
  name           = "diplom-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.this.id
  v4_cidr_blocks = ["10.0.1.0/24"]
}



# Группа безопасности

resource "yandex_vpc_security_group" "this" {
  name        = "diplom-sg"
  description = "Группа безопасности для дипломного проекта"
  network_id  = yandex_vpc_network.this.id

  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "SSH"
  }

  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTP"
  }

  ingress {
    protocol       = "TCP"
    port           = 443
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTPS"
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Исходящий трафик"
  }

  ingress {
    protocol       = "TCP"
    port           = 5000
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "FastAPI"
  }
}



# Виртуальная машина

data "yandex_compute_image" "this" {
  family = "ubuntu-2004-lts"
}

resource "yandex_compute_instance" "this" {
  name        = "diplom-vm"
  platform_id = "standard-v3"
  zone        = var.zone

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.this.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.this.id
    security_group_ids = [yandex_vpc_security_group.this.id]
    nat                = true
  }

  metadata = {
    user-data          = templatefile("${path.module}/cloud-init.yml", {
      vm_username      = var.vm_username
      ssh_public_key   = var.public_key
      package_update   = var.package_update
      package_upgrade  = var.package_upgrade
      packages         = jsonencode(var.packages)
    })
    serial-port-enable = 1
  }

  scheduling_policy {
    preemptible = true
  }
}



# Кластер MySQL

resource "yandex_mdb_mysql_cluster" "this" {
  name                = "diplom-mysql"
  environment         = "PRESTABLE"
  network_id          = yandex_vpc_network.this.id
  version             = "8.0"
  deletion_protection = false

  resources {
    resource_preset_id = "s2.micro"
    disk_type_id       = "network-hdd"
    disk_size          = 10
  }

  host {
    zone             = var.zone
    subnet_id        = yandex_vpc_subnet.this.id
    assign_public_ip = false
  }
}

resource "yandex_mdb_mysql_database" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = "diplom_db"
}

resource "yandex_mdb_mysql_user" "this" {
  cluster_id = yandex_mdb_mysql_cluster.this.id
  name       = "app"
  password   = var.db_password

  permission {
    database_name = yandex_mdb_mysql_database.this.name
    roles         = ["ALL"]
  }
}



# Container Registry

resource "yandex_container_registry" "this" {
  name = "diplom-registry"
}
