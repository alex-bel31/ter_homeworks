resource "yandex_compute_disk" "disks" {
  count = 3
  name     = "${var.disks.storage.name}-${count.index+1}"
  type     = var.disks.storage.type
  zone     = var.default_zone
  size = var.disks.storage.size
}

resource "yandex_compute_instance" "storage" {

  name        = "storage"
  platform_id = var.vms_resources.platform_id
  zone        = var.default_zone

  resources {
    cores         = var.vms_resources.cores
    memory        = var.vms_resources.memory
    core_fraction = var.vms_resources.core_fraction
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
    nat                = true
  }

  metadata = {
    ssh-keys = local.public_key
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.disks

    content {
      disk_id = secondary_disk.value.id
      auto_delete = true
    }
  }
}