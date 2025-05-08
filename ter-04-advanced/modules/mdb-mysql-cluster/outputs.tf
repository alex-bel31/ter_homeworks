output "cluster_id" {
  description = "MySQL cluster ID"
  value       = yandex_mdb_mysql_cluster.mdb_mysql_cluster.id
}

output "cluster_name" {
  description = "MySQL cluster name"
  value       = yandex_mdb_mysql_cluster.mdb_mysql_cluster.name
}
