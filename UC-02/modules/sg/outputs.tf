output "web_sg_id" {
  value = aws_security_group.web.id
}
output "rds_sg_id" {
  value = aws_security_group.rds.id
}
