# modules/rds/main.tf
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.mysql_subnet.name
  vpc_security_group_ids = [var.rds_sg_id]
  multi_az             = true
  skip_final_snapshot  = true
}

resource "aws_db_subnet_group" "mysql_subnet" {
  name       = "mysql-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags       = { Name = "mysql-subnet-group" }
}
