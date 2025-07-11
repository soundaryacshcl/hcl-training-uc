provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "security_groups" {
  source  = "./modules/security_groups"
  vpc_id  = module.vpc.vpc_id
  my_ip   = var.my_ip
}

module "ec2" {
  source             = "./modules/ec2"
  ami_id             = var.ami_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  web_sg_id          = module.security_groups.web_sg_id
  rds_endpoint       = module.rds.rds_endpoint
  db_user            = var.db_user
  db_password        = var.db_password
  db_name            = var.db_name
}

module "rds" {
  source              = "./modules/rds"
  db_name             = var.db_name
  db_user             = var.db_user
  db_password         = var.db_password
  private_subnet_ids  = module.vpc.private_subnet_ids
  rds_sg_id           = module.security_groups.rds_sg_id
}
