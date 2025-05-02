###cloud vars
variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

## -----------------network vars-----------------

variable "default_cidr" {
  type        = list(string)
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

## -----------------vm vars-----------------

locals {
  public_key = "ubuntu:${file("~/.ssh/yavm.pub")}"
}

variable "vms_resources" {
  type = object({
    cores         = number
    memory        = number
    core_fraction = number
    platform_id   = string
    image_family  = string
  })
  description = "Resource configuration for count_vm"
  sensitive   = true
}

variable "each_vm" {
  type = list(object({
    vm_name       = string,
    cpu           = number,
    ram           = number,
    core_fraction = number
    disk_volume   = number
  }))
  description = "Resource configuration for each_vm"
}

variable "disks" {
  type = map(object({
    name = string
    type = string
    size = number
  }))
  description = "Options for virtual disks"
}