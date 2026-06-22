#создаем облачную сеть
module "vpc_dev" {
  source = "./vpc"
  cloud_id = var.cloud_id
  folder_id = var.folder_id
  vpc_name = var.network_name
  default_zone = var.zone
  default_cidr = var.subnet_a_cidr
}


module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "marketing"
  network_id     = module.vpc_dev.network_id
  subnet_zones   = [module.vpc_dev.subnet_zone]
  subnet_ids     = [module.vpc_dev.subnet_id]
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
  network_id     = module.vpc_dev.network_id
  subnet_zones   = [module.vpc_dev.subnet_zone]
  subnet_ids     = [module.vpc_dev.subnet_id]
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


module "s3_bucket" {
  source = "git::https://github.com/terraform-yc-modules/terraform-yc-s3"

  bucket_name = "terraform-state-netology"
  max_size    = 1073741824  # 1 ГБ
  acl         = "private"

  versioning = {
    enabled = true
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
