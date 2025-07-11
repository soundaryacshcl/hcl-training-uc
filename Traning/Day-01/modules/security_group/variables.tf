
variable "sg_name" {
  description = "sg names"
  type        = string
  default    = "security_group_eks"

}
variable "vpc_id" {
  description = "List of CIDR blocks for vpc"
  type        = string
}
