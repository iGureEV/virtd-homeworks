### -----------------------------------------------
### ВМ через for_each

variable "each_vm" {
  type = list(object({
    vm_name     = string
    cpu         = number
    ram         = number
    disk_volume = number
  }))
  default = [
    {
      vm_name     = "main"
      cpu         = 4
      ram         = 4
      disk_volume = 10
    },
    {
      vm_name     = "replica"
      cpu         = 2
      ram         = 2
      disk_volume = 5
    }
  ]
  description = "Основные параметры ВМ создаваемых через for_each"
}


### -----------------------------------------------
### Общие параметры

locals {
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}

variable "vm_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "ИД платформы"
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Образ ОС"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
    disk_volume   = number
  }))
  default = {
    count_vm = {
      cores         = 2
      memory        = 2
      core_fraction = 5
      disk_volume   = 5
    }
    storage = {
      cores         = 2
      memory        = 2
      core_fraction = 5
      disk_volume   = 5
    }
  }
  description = "Основные параметры ВМ"
}
