module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "custom-vpc"
  cidr = var.vpc_cidr

  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway  = true
  single_nat_gateway  = true

  public_subnet_tags = {
    for index, subnet in var.public_subnets :
    "Name" => "public-subnet-${index + 1}"
  }

  private_subnet_tags = {
    for index, subnet in var.private_subnets :
    "Name" => "private-subnet-${index + 1}"
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
