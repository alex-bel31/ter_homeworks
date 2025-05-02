locals {
  vm_map = { for vm in var.each_vm : vm.vm_name => vm }
}

resource "yandex_compute_instance" "for_each_vm" {

  for_each    = local.vm_map
  name        = each.value.vm_name
  platform_id = var.vms_resources.platform_id
  zone        = var.default_zone

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = local.public_key
  }
}