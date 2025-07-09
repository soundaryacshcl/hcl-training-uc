output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The list of public subnet IDs"
  value       = aws_subnet.public[*].id
}
