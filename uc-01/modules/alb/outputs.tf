output "security_group_id" {
  value = aws_security_group.alb_sg.id
}


output "target_group_arns" {
  description = "Map of target group ARNs for EC2 attachment"
  value = {
    app1 = aws_lb_target_group.app1.arn
    app2 = aws_lb_target_group.app2.arn
    app3 = aws_lb_target_group.app3.arn
  }
}
