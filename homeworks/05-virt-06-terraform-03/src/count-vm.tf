resource "yandex_compute_instance" "web" {
  count       = 2
  depends_on = [yandex_compute_instance.db]
  name        = "web-${count.index + 1}"  # даст имена web-1 и web-2
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vms_resources["count_vm"].cores
    memory        = var.vms_resources["count_vm"].memory
    core_fraction = var.vms_resources["count_vm"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["count_vm"].disk_volume
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}
