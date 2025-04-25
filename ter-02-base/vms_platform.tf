variable "vm_name" {
  type        = list(string)
  default     = ["web", "db"]
  description = "Name of the VM"
}

variable "image_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Image family for VM"
}

variable "platform_id" {
  type        = string
  default     = "standard-v3"
  description = "Platform ID"
}

variable "vms_resources" {
  type = map(object({
    cores         = number
    memory        = number
    core_fraction = number
  }))
  default = {
    vm_web = {
      cores         = 2
      memory        = 1
      core_fraction = 20
    }
    vm_db = {
      cores         = 2
      memory        = 2
      core_fraction = 20
    }
  }
  description = "Defines resource configuration for VM"
}

## vm_web vars

# variable "vm_web_cores" {
#   type        = number
#   default     = 2
#   description = "Number of CPU cores"
# }

# variable "vm_web_memory" {
#   type        = number
#   default     = 1
#   description = "Amount of RAM"
# }

# variable "vm_web_core_fraction" {
#   type        = number
#   default     = 20
#   description = "Core fraction"
# }

## vm_web vars

# variable "vm_db_cores" {
#   type        = number
#   default     = 2
#   description = "Number of CPU cores"
# }

# variable "vm_db_memory" {
#   type        = number
#   default     = 2
#   description = "Amount of RAM"
# }

# variable "vm_db_core_fraction" {
#   type        = number
#   default     = 20
#   description = "Core fraction"
# }

