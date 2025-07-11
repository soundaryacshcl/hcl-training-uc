variable "subnet_ids" {}
variable "sg_id" {}
variable "db_subnet_group_name" {}

resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = var.subnet_ids
  tags       = { Name = "RDS subnet group" }
}


resource "aws_db_instance" "mysql" {
 identifier             = "mydb"
 allocated_storage      = 20
 engine                 = "mysql"
 engine_version         = "8.0"
 instance_class         = "db.t3.micro"
 username               = "admin"
 password               = "Password123"
 db_subnet_group_name   = aws_db_subnet_group.rds.name
 vpc_security_group_ids = [var.sg_id]
 skip_final_snapshot    = true
}


