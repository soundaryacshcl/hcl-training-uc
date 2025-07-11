# modules/ec2/main.tf
resource "aws_instance" "web" {
  count         = 2
  ami           = var.ami_id
  instance_type = "t2.micro"
  subnet_id     = var.public_subnet_ids[count.index]
  security_groups = [var.web_sg_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello from Web Server ${count.index}" > /var/www/html/index.html
              EOF

  tags = { Name = "web-server-${count.index}" }
}
