output "instances_info" {
  value = concat([
    for vm in yandex_compute_instance.count_vm : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
    }],
    [for vm in values(yandex_compute_instance.for_each_vm) : {
      name = vm.name
      id   = vm.id
      fqdn = vm.fqdn
  }])
}
