provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "main-vpc"
    Environment = "dev"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Subnets
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-a"
  }
}

resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-b"
  }
}

resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-c"
  }
}

# Route Table Associations
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.public_rt.id
}
resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}

# Load Balancer
resource "aws_lb" "alb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet_a.id, aws_subnet.subnet_b.id, aws_subnet.subnet_c.id]
  tags = {
    Name = "app-alb"
  }
}

# Target Groups
resource "aws_lb_target_group" "app1" {
  name     = "app1tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/app1/index.html"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app1-tg"
  }
}

resource "aws_lb_target_group" "app2" {
  name     = "app2tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/image/index.html"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app2-tg"
  }
}

resource "aws_lb_target_group" "app3" {
  name     = "app3tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/register/index.html"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "app3-tg"
  }
}

# Listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1.arn
  }
}

# Listener Rules
resource "aws_lb_listener_rule" "app2_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app2.arn
  }

  condition {
    path_pattern {
      values = ["/image", "/image/*"]
    }
  }
}

resource "aws_lb_listener_rule" "app3_rule" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app3.arn
  }

  condition {
    path_pattern {
      values = ["/register", "/register/*"]
    }
  }
}

# EC2 Instances
resource "aws_instance" "app1" {
  ami                         = "ami-05ffe3c48a9991133"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_a.id
  vpc_security_group_ids      = [aws_security_group.alb_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              mkdir -p /var/www/html/app1

              cat <<EOT > /var/www/html/app1/index.html
              <html>
              <head><title>App1</title></head>
              <body>
              <h1>Home Page !</h1>
              <p>(Instance A)</p>
              </body>
              </html>
              EOT

              echo "<VirtualHost *:80>
                Alias /app1 /var/www/html/app1
                <Directory /var/www/html/app1>
                  Require all granted
                  AllowOverride All
                </Directory>
              </VirtualHost>" > /etc/httpd/conf.d/app1.conf

              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "app1-instance"
  }
}

resource "aws_instance" "app2" {
  ami                         = "ami-05ffe3c48a9991133"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_b.id
  vpc_security_group_ids      = [aws_security_group.alb_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              mkdir -p /var/www/html/image

              cat <<EOT > /var/www/html/image/index.html
              <html>
              <head><title>App2</title></head>
              <body>
              <h1>Images !</h1>
              <p>(Instance B)</p>
              </body>
              </html>
              EOT

              echo "<VirtualHost *:80>
                Alias /image /var/www/html/image
                <Directory /var/www/html/image>
                  Require all granted
                  AllowOverride All
                </Directory>
              </VirtualHost>" > /etc/httpd/conf.d/image.conf

              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "app2-instance"
  }
}

resource "aws_instance" "app3" {
  ami                         = "ami-05ffe3c48a9991133"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.subnet_c.id
  vpc_security_group_ids      = [aws_security_group.alb_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              mkdir -p /var/www/html/register

              cat <<EOT > /var/www/html/register/index.html
              <html>
              <head><title>App3</title></head>
              <body>
              <h1>Register !</h1>
              <p>(Instance C)</p>
              </body>
              </html>
              EOT

              echo "<VirtualHost *:80>
                Alias /register /var/www/html/register
                <Directory /var/www/html/register>
                  Require all granted
                  AllowOverride All
                </Directory>
              </VirtualHost>" > /etc/httpd/conf.d/register.conf

              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "app3-instance"
  }
}

# Target Group Attachments
resource "aws_lb_target_group_attachment" "app1_target" {
  target_group_arn = aws_lb_target_group.app1.arn
  target_id        = aws_instance.app1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app2_target" {
  target_group_arn = aws_lb_target_group.app2.arn
  target_id        = aws_instance.app2.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "app3_target" {
  target_group_arn = aws_lb_target_group.app3.arn
  target_id        = aws_instance.app3.id
  port             = 80
}

# Backend Configuration
terraform {
  backend "s3" {
    bucket = "hcl-training-uc-01-bucket"
    key    = "uc-01/terraform.tfstate"
    region = "us-east-1"
  }
}
