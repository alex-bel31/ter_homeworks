data "yandex_compute_image" "ubuntu" {
  family = var.vms_resources.image_family
}

resource "yandex_compute_instance" "count_vm" {

  depends_on  = [yandex_compute_instance.for_each_vm]
  count       = 2
  name        = "web-${count.index + 1}"
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
    security_group_ids = [yandex_vpc_security_group.example.id]
    nat                = true
  }

  metadata = {
    ssh-keys = local.public_key
  }
}