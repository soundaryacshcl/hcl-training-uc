output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "web_sg_id" {
  value = module.security_groups.web_sg_id
}

output "rds_sg_id" {
  value = module.security_groups.rds_sg_id
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}
