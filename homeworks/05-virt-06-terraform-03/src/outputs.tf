output "all_vms" {
  value = concat(
    yandex_compute_instance.web[*],
    values(yandex_compute_instance.db),
    [yandex_compute_instance.storage]
  )
  description = "Список всех ВМ с именами, ид и fqdn"
}
