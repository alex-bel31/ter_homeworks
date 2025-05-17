variable "ip_addr" {
  type = string
  description = "ip-addres"
  default = "1920.1680.0.1"
  validation {
    condition = can(regex(
      "^((25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})$",
      var.ip_addr
    ))
    error_message = "The variable must contain a valid IPv4 address."
  }
}

variable "ip_addr_list" {
  type = list(string)
  description = "List ip-addres"
  default = ["192.168.0.1", "1.1.1.1", "1270.0.0.1"]
  validation {
    condition = alltrue([for ip in var.ip_addr_list : can(regex(
      "^((25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})\\.){3}(25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})$",
      ip
    ))])
    error_message = "All values in the list must be valid IPv4 addresses."
  }
}

variable "any_string" {
  type = string
  description = "Any string"
  default = "Test"
  validation {
    condition = lower(var.any_string) == var.any_string
    error_message = "The string must not contain uppercase characters"
  }
}

variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = false
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = (var.in_the_end_there_can_be_only_one.Dunkan != var.in_the_end_there_can_be_only_one.Connor)
    }
}