output "databases" {
  description = "A list of databases names."
  value       = [for db in var.databases : db.name]
}