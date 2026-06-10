### Певая ВМ

variable "vm_web_default_zone" {
  type        = string
  default     = "ru-central1-e"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_web_default_cidr" {
  type        = list(string)
  default     = ["10.131.0.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_web_vpc_name" {
  type        = string
  default     = "develop_e"
  description = "VPC network & subnet name"
}

variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Web VM name"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Web VM platform ID"
}

variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Web VM cores"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "Web VM memory (GB)"
}

variable "vm_web_core_fraction" {
  type        = number
  default     = 5
  description = "Web VM core fraction"
}

variable "vm_web_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Web VM image family"
}

### Вторая ВМ

variable "vm_db_default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.129.0.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "develop_b"
  description = "VPC network & subnet name"
}

variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "DB VM name"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v2"
  description = "DB VM platform ID"
}

variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "DB VM cores"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "DB VM memory (GB)"
}

variable "vm_db_core_fraction" {
  type        = number
  default     = 20
  description = "DB VM core fraction"
}

variable "vm_db_image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "DB VM image family"
}
