variable "databases" {
  description = "List of MySQL databases"
  type = list(object({
    name = string
  }))
  default = []
}

variable "users" {
  description = "MySQL user list"
  type = list(object({
    name     = string
    password = string
  }))
  default = []
}

variable "cluster_id" {
  type        = string
  description = "Cluster ID"
}