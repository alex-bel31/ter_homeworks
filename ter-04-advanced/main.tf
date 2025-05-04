module "vpc_dev" {
  source = "./modules/vpc"
  network_name = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}

module "vpc_stage" {
  source = "./modules/vpc"
  network_name = "stage"
  zone = "ru-central1-b"
  cidr = "10.0.2.0/24"
}

module "test-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "develop" 
  network_id     = module.vpc_dev.subnet_info.network_id
  subnet_zones   = [module.vpc_dev.subnet_info.zone]
  subnet_ids     = [module.vpc_dev.subnet_info.id]
  instance_name  = "webs"
  instance_count = 2
  image_family   = var.image_family
  public_ip      = true

  labels = { 
    project = "marketing"
    }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered 
    serial-port-enable = 1
  }

}

module "example-vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name       = "stage"
  network_id     = module.vpc_stage.subnet_info.network_id
  subnet_zones   = [module.vpc_stage.subnet_info.zone]
  subnet_ids     = [module.vpc_stage.subnet_info.id]
  instance_name  = "web-stage"
  instance_count = 1
  image_family   = var.image_family
  public_ip      = true

  labels = { 
    project = "analytics"
    }

  metadata = {
    user-data          = data.template_file.cloudinit.rendered 
    serial-port-enable = 1
  }

}

data "template_file" "cloudinit" {
  template = file("./cloud-init.yml")
    vars = {
    username           = var.ssh_username
    ssh_public_key     = local.public_key
  }
}