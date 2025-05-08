###cloud vars
variable "cloud_id" {
  type        = string
  description = "Cloud ID"
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
}

variable "default_zone" {
  type        = string
  description = "Default zone"
}
variable "default_cidr" {
  type        = list(string)
  description = "Default cidr"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}

locals {
  public_key = file("~/.ssh/yavm.pub")
}

variable "ssh_username" {
  type = string
}

variable "subnets" {
  type = map(object({
    zone = string
    cidr = string
  }))
  description = "List of subnets with zones and CIDR"
}

variable "image_family" {
  type        = string
  description = "Image family for VM"
}