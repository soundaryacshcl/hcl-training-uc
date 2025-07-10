module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = "my-ec2-instance"

  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = module.vpc.public_subnets[0]

  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  tags = {
    Name        = "modules-instance"
    Environment = "dev"
  }
}
