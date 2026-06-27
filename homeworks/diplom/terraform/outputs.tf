output "vm_external_ip" {
  value = yandex_compute_instance.this.network_interface[0].nat_ip_address
  description = "Внешний IP-адрес ВМ"
}

output "mysql_host_fqdn" {
  value = yandex_mdb_mysql_cluster.this.host[0].fqdn
  description = "FQDN хоста MySQL"
}

output "mysql_database" {
  value = yandex_mdb_mysql_database.this.name
  description = "Имя базы данных"
}

output "mysql_user" {
  value = yandex_mdb_mysql_user.this.name
  description = "Имя пользователя БД"
}

output "registry_id" {
  value = yandex_container_registry.this.id
  description = "ID Container Registry"
}
