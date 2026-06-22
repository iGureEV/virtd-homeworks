terraform {
  required_providers {
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.116.0"
    }
  }
  required_version = "~>1.15.6"
}

provider "yandex" {
  # token                    = "do not use!!!"
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  service_account_key_file = file("~/.authorized_key.json")
  zone                     = "ru-central1-e" #(Optional) 
}
