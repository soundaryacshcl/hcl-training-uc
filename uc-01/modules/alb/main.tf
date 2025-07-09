resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_lb" "alb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets
  tags = {
    Name = "app-alb"
  }
}

# Target Groups
resource "aws_lb_target_group" "app1" {
  name     = "app1tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/app1/index.html"
  }
}

resource "aws_lb_target_group" "app2" {
  name     = "app2tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/image/index.html"
  }
}

resource "aws_lb_target_group" "app3" {
  name     = "app3tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path = "/register/index.html"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app1.arn
  }
}

resource "aws_lb_listener_rule" "app2" {
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

resource "aws_lb_listener_rule" "app3" {
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
