variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}



variable "my_ip" {
  description = "Your IP address for SSH access"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-05ffe3c48a9991133"
}


