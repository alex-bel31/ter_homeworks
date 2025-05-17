variable "cloud_id" {
  type        = string
  description = "Cloud ID"
  sensitive = true
}

variable "folder_id" {
  type        = string
  description = "Folder ID"
  sensitive = true
}

variable "default_zone" {
  type        = string
  description = "Default zone"
  sensitive = true
}

variable "ssh_username" {
  type = string
  sensitive = true
}

variable "image_family" {
  type        = string
  description = "Image family for VM"
  sensitive = true
}