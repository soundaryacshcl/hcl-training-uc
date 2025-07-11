variable "subnet_ids" {}
variable "sg_id" {}
variable "instance_count" {}

resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = "var.ami_id"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_ids[count.index]
  vpc_security_group_ids = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Web Server ${count.index + 1}</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "WebServer-${count.index + 1}"
  }
}
