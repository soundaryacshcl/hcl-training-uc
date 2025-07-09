variable "vpc_id" {
  description = "VPC ID for the ALB and security group"
  type        = string
}

variable "subnets" {
  description = "List of public subnet IDs for ALB"
  type        = list(string)
}

