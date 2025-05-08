resource "yandex_mdb_mysql_cluster" "mdb_mysql_cluster" {
  name        = var.name
  environment = var.environment
  network_id  = var.network_id
  version     = var.mysql_version

  resources {
    resource_preset_id = var.resource_preset_id
    disk_type_id       = var.disk_type
    disk_size          = var.disk_size
  }

  dynamic "host" {
    for_each = var.ha ? [0, 1] : [0]
    content {
      name      = "${var.name}-host-${host.key}"
      zone      = var.subnets[host.key].zone
      subnet_id = var.subnets[host.key].subnet_id
    }
  }
}