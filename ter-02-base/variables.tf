###cloud vars

variable "cloud_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  sensitive   = true
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

## network_vars

variable "vm_zone" {
  type = map(string)
  default = {
    "zone-a" = "ru-central1-a",
    "zone-b" = "ru-central1-b"
  }
  description = "Accessibility zones"
}

variable "vpc_net_name" {
  type        = string
  default     = "develop"
  description = "VPC network name"
}

variable "vm_vpc_subnet_name" {
  type = map(string)
  default = {
    "db"  = "db-develop"
    "web" = "web-develop"
  }
  description = "VPC subnet name"
}

variable "vm_default_cidr" {
  type = map(list(string))
  default = {
    "db"  = ["10.0.2.0/24"]
    "web" = ["10.0.1.0/24"]
  }
}

variable "nat_gateway_name" {
  type        = string
  default     = "netology-gateway"
  description = "Name nat-gateway"
}

variable "route_table_name" {
  type        = string
  default     = "develop-route-table"
  description = "Name nat-gateway"
}

###ssh vars

variable "vms_metadata" {
  type        = map(string)
  sensitive   = true
  description = "VM Metadata(port, ssh)"
}


