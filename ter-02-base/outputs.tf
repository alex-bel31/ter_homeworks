# instance_name, external_ip, fqdn 

output "instances_info" {
  value = {
    web_platform = {
      instance_name = yandex_compute_instance.web_platform.name
      external_ip   = yandex_compute_instance.web_platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.web_platform.fqdn
    }
    db_platform = {
      instance_name = yandex_compute_instance.db_platform.name
      external_ip   = yandex_compute_instance.db_platform.network_interface[0].nat_ip_address
      fqdn          = yandex_compute_instance.db_platform.fqdn
    }
  }
}
