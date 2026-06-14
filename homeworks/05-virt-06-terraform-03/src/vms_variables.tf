### ВМ через loop count

variable "vm_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "count VM platform ID"
}

variable "vm_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "count VM image family"
}


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
}


### Общие переменные

locals {
  ssh_public_key = file("~/.ssh/id_rsa.pub")
}
