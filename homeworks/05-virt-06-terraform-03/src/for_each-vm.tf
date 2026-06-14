resource "yandex_compute_instance" "db" {
  for_each    = toset([for vm in var.each_vm : vm.vm_name])
  name        = each.value
  platform_id = var.vm_platform_id
  zone        = var.default_zone
  allow_stopping_for_update   = true

  resources {
    cores         = var.each_vm[index(var.each_vm.*.vm_name, each.value)].cpu
    memory        = var.each_vm[index(var.each_vm.*.vm_name, each.value)].ram
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.each_vm[index(var.each_vm.*.vm_name, each.value)].disk_volume
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = false
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}
