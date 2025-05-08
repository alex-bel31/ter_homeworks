resource "yandex_mdb_mysql_database" "database" {
  for_each   = length(var.databases) > 0 ? { for db in var.databases : db.name => db } : {}
  cluster_id = var.cluster_id
  name       = lookup(each.value, "name", null)
}

resource "yandex_mdb_mysql_user" "user" {
  for_each   = length(var.users) > 0 ? { for user in var.users : user.name => user } : {}
  cluster_id = var.cluster_id
  name       = each.value.name
  password   = each.value.password
  depends_on = [yandex_mdb_mysql_database.database]
}