# Три диска созданные через count
resource "yandex_compute_disk" "storage_disks" {
  count = 3
  name  = "storage-disk-${count.index + 1}"
  type  = "network-hdd"
  zone  = var.default_zone
  size  = var.vms_resources["storage"].disk_volume
}

# ВМ storage с dynamic secondary_disk
resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = var.vm_platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vms_resources["storage"].cores
    memory        = var.vms_resources["storage"].memory
    core_fraction = var.vms_resources["storage"].core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = var.vms_resources["storage"].disk_volume
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.storage_disks
    content {
      disk_id = secondary_disk.value.id
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
