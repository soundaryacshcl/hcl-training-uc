module "vpc" {
  source = "./modules/vpc"
}

module "sg" {
  source = "./modules/sg"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source          = "./modules/ec2"
  subnet_ids      = module.vpc.public_subnet_ids
  ami_id          =  var.ami_id
  sg_id           = module.sg.web_sg_id
  instance_count  = 2
}

module "rds" {
  source               = "./modules/rds"
  subnet_ids           = module.vpc.private_subnet_ids
  sg_id                = module.sg.rds_sg_id
  db_subnet_group_name = module.rds.db_subnet_group
}
