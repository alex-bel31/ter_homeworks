resource "yandex_vpc_network" "develop" {
  name = var.vpc_net_name
}

resource "yandex_vpc_subnet" "web_develop" {
  name           = var.vm_vpc_subnet_name["web"]
  zone           = var.vm_zone["zone-a"]
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_default_cidr["web"]
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_subnet" "db_develop" {
  name           = var.vm_vpc_subnet_name["db"]
  zone           = var.vm_zone["zone-b"]
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.vm_default_cidr["db"]
  route_table_id = yandex_vpc_route_table.rt.id
}

resource "yandex_vpc_gateway" "nat_gateway" {
  name = var.nat_gateway_name
  shared_egress_gateway {}
}

resource "yandex_vpc_route_table" "rt" {
  name       = var.route_table_name
  network_id = yandex_vpc_network.develop.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat_gateway.id
  }
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_family
}

resource "yandex_compute_instance" "web_platform" {
  name        = local.vm_web_name
  platform_id = var.platform_id
  zone        = var.vm_zone["zone-a"]
  resources {
    cores         = var.vms_resources["vm_web"].cores
    memory        = var.vms_resources["vm_web"].memory
    core_fraction = var.vms_resources["vm_web"].core_fraction
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
    subnet_id = yandex_vpc_subnet.web_develop.id
    nat       = false
  }

  metadata = var.vms_metadata
}

resource "yandex_compute_instance" "db_platform" {
  name        = local.vm_db_name
  platform_id = var.platform_id
  zone        = var.vm_zone["zone-b"]
  resources {
    cores         = var.vms_resources["vm_db"].cores
    memory        = var.vms_resources["vm_db"].memory
    core_fraction = var.vms_resources["vm_db"].core_fraction
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
    subnet_id = yandex_vpc_subnet.db_develop.id
    nat       = false
  }

  metadata = var.vms_metadata

}
