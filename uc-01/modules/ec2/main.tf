locals {
  apps = {
    app1 = {
      path     = "/"
      html     = "Home Page"
      subnet   = var.subnets[0]
      health   = "/index.html"
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
  for_each                    = local.apps
  ami                         = "ami-05ffe3c48a9991133"
  instance_type               = "t2.micro"
  subnet_id                   = each.value.subnet
  vpc_security_group_ids      = [var.alb_sg_id]
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/apache_setup.sh.tpl", {
  path = each.value.path
  html = each.value.html
  name = each.key
  })


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
