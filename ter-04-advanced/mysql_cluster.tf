module "vpc" {
  source   = "./modules/vpc-all-zones"
  env_name = "prod"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" }
  ]
}

module "mysql" {
  source = "./modules/mdb-mysql-cluster"
  name   = "example"
  ha     = false
  network_id = module.vpc.subnet_info[0].network_id

  subnets = [
    for s in module.vpc.subnet_info : {
      subnet_id = s.id
      zone      = s.zone
    }
  ]
}

module "mysql_db_user" {
  source     = "./modules/mysql-db-user"
  cluster_id = module.mysql.cluster_id
  databases  = [{ name = "test" }]
  users = [{
    name     = "app"
    password = "Password123!"
  }]
}