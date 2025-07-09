locals {
  apps = {
    app1 = {
      path     = "/app1"
      html     = "Home Page"
      subnet   = var.subnets[0]
      health   = "/app1/index.html"
    }
    app2 = {
      path     = "/image"
      html     = "Images"
      subnet   = var.subnets[1]
      health   = "/image/index.html"
    }
    app3 = {
      path     = "/register"
      html     = "Register"
      subnet   = var.subnets[2]
      health   = "/register/index.html"
    }
  }
}

resource "aws_instance" "apps" {
  for_each                     = local.apps
  ami                          = "ami-05ffe3c48a9991133"
  instance_type                = "t2.micro"
  subnet_id                    = each.value.subnet
  vpc_security_group_ids       = [var.alb_sg_id]
  associate_public_ip_address  = true

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              mkdir -p /var/www/html${each.value.path}

              cat <<EOT > /var/www/html${each.value.path}/index.html
              <html><head><title>${each.key}</title></head>
              <body><h1>${each.value.html}!</h1><p>(${each.key})</p></body></html>
              EOT

              echo "<VirtualHost *:80>
                Alias ${each.value.path} /var/www/html${each.value.path}
                <Directory /var/www/html${each.value.path}>
                  Require all granted
                </Directory>
              </VirtualHost>" > /etc/httpd/conf.d/${each.key}.conf

              rm -f /etc/httpd/conf.d/welcome.conf
              systemctl start httpd
              systemctl enable httpd
              EOF

  tags = {
    Name = "${each.key}-instance"
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  for_each         = local.apps
  target_group_arn = var.tg_arns[each.key]
  target_id        = aws_instance.apps[each.key].id
  port             = 80
}
