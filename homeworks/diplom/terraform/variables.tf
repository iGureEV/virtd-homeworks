variable "cloud_id" {
  type        = string
  description = "ID облака в Yandex Cloud"
}

variable "folder_id" {
  type        = string
  description = "ID каталога в Yandex Cloud"
}

variable "zone" {
  type        = string
  default     = "ru-central1-a"
  description = "Зона доступности по умолчанию"
}

variable "public_key" {
  type        = string
  description = "Содержимое публичного SSH-ключа (cat ~/.ssh/id_ed25519.pub)"
}

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

variable "db_password" {
  type        = string
  description = "Пароль пользователя БД MySQL"
  sensitive   = true
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
  default     = [
    "nano", "curl", "htop", "jq",
    "apt-transport-https",
    "ca-certificates",
    "software-properties-common",
  ]
  description = "Список пакетов для установки"
}