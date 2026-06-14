resource "yandex_compute_instance" "web" {
  count       = 2
  depends_on = [yandex_compute_instance.db]
  name        = "web-${count.index + 1}"  # даст имена web-1 и web-2
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 5
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.develop.id
    nat                = false
    security_group_ids = [yandex_vpc_security_group.example.id]
  }

  metadata = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:${local.ssh_public_key}"
  }
}
