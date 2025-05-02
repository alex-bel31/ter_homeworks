locals {
  web     = yandex_compute_instance.count_vm
  db      = values(yandex_compute_instance.for_each_vm)
  storage = [yandex_compute_instance.storage]
}

resource "local_file" "ansible_inventory" {
  content = templatefile("${path.module}/hosts.tftpl",
    { web = local.web,
      db  = local.db,
  storage = local.storage })

  filename = "${abspath(path.module)}/hosts.ini"

}