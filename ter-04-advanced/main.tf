module "vpc_prod" {
  source   = "./modules/vpc-all-zones"
  env_name = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-d", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source   = "./modules/vpc-all-zones"
  env_name = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}

module "test-vm" {
  source                 = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=711baa1"
  env_name               = "production"
  network_id             = module.vpc_prod.subnet_info[0].id
  subnet_zones           = [for subnet in module.vpc_prod.subnet_info : subnet.zone]
  subnet_ids             = [for subnet in module.vpc_prod.subnet_info : subnet.id]
  instance_name          = "webs"
  instance_count         = 3
  image_family           = var.image_family
  public_ip              = true
  platform               = "standard-v3"
  instance_core_fraction = 20

  labels = {
    project = "marketing"
  }

  metadata = {
    user-data          = local.cloudinit
    serial-port-enable = 1
  }

}

module "example-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=711baa1"
  env_name       = "develop"
  network_id     = module.vpc_dev.subnet_info[0].id
  subnet_zones   = [for subnet in module.vpc_dev.subnet_info : subnet.zone]
  subnet_ids     = [for subnet in module.vpc_dev.subnet_info : subnet.id]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true

  labels = {
    project = "analytics"
  }

  metadata = {
    user-data          = local.cloudinit
    serial-port-enable = 1
  }
}

locals {
  cloudinit = templatefile("${path.module}/cloud-init.yml", {
    username       = var.ssh_username
    ssh_public_key = file("~/.ssh/yavm.pub")
  })
}