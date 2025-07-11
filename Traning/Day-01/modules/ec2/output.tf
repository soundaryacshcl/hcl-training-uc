output "instance_a_id" {
  description = "ID of Instance A (Homepage)"
  value       = aws_instance.instance_a.id
}


output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}
