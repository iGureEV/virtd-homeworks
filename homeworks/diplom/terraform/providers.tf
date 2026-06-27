terraform {
  required_providers {
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.116.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "> 5.1.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-state-netology"
    key     = "terraform.tfstate"
    region  = "ru-central1"

    # Встроенная блокировка (Terraform >= 1.6)
    # Не требует отдельной базы данных!
    use_lockfile = true

    endpoints = {
      s3 = "https://storage.yandexcloud.net"
    }

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
  required_version = ">= 1.15.0"
}

provider "yandex" {
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
  service_account_key_file = file(pathexpand("~/.authorized_key.json"))
}

provider "aws" {
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  region                      = "ru-central1"
  access_key                  = var.storage_access_key
  secret_key                  = var.storage_secret_key
}
