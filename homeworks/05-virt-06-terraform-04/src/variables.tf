###cloud vars

variable "cloud_id" {
  type        = string
  default     = ""
  description = "ID облака Yandex Cloud"
}

variable "folder_id" {
  type        = string
  default     = ""
  description = "ID каталога Yandex Cloud"
}

variable "public_key" {
  type        = string
  default     = ""
  description = "ssh-keygen -t ed25519"
}

variable "platform_id" {
  type        = string
  default     = "standard-v2"
  description = "Платформа для ВМ (standard-v1, standard-v2, standard-v3)"
}

###network vars

variable "network_name" {
  type        = string
  default     = "develop"
  description = "Имя облачной сети"
}

variable "zone" {
  type        = string
  default     = "ru-central1-e"
  description = "Зона доступности"
}

variable "subnet_a_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "CIDR блок подсети A"
}

variable "subnet_b_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "CIDR блок подсети B"
}

###vm vars

variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа для ВМ"
}

variable "public_ip" {
  type        = bool
  default     = true
  description = "Назначать публичный IP"
}

###cloud-init vars

variable "vm_username" {
  type        = string
  default     = "ubuntu"
  description = "Имя пользователя для ВМ"
}

variable "package_update" {
  type        = bool
  default     = true
  description = "Обновлять пакеты при создании ВМ"
}
variable "package_upgrade" {
  type        = bool
  default     = false
  description = "Обновлять версии пакетов при создании ВМ"
}

variable "packages" {
  type        = list(string)
  default     = ["nano", "nginx"]
  description = "Список пакетов для установки"
}

###s3 vars

variable "storage_access_key" {
  type        = string
  default     = ""
  description = "Статический ключ доступа для S3 (access key)"
}

variable "storage_secret_key" {
  type        = string
  default     = ""
  description = "Статический ключ доступа для S3 (secret key)"
}

