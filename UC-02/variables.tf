variable "aws_region" {
  default = "us-east-1"
}
variable "rds_username" {
  type      = string
  sensitive = true
}

variable "rds_password" {
  type      = string
  sensitive = true
}
