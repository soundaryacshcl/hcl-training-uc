module "network" {
  source = "./modules/network"
}

module "alb" {
  source  = "./modules/alb"
  vpc_id  = module.network.vpc_id
  subnets = module.network.public_subnet_ids
}

module "ec2" {
  source     = "./modules/ec2"
  vpc_id     = module.network.vpc_id
  subnets    = module.network.public_subnet_ids  # ✅ fixed name
  alb_sg_id  = module.alb.security_group_id
}
