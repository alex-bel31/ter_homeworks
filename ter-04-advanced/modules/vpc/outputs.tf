output "subnet_info" {
    value = {
    id           = yandex_vpc_subnet.subnet.id
    name         = yandex_vpc_subnet.subnet.name
    zone         = yandex_vpc_subnet.subnet.zone
    cidr         = yandex_vpc_subnet.subnet.v4_cidr_blocks[0]
    network_id   = yandex_vpc_subnet.subnet.network_id
  }
  description = "Information about the created subnetwork"
}