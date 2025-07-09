variable "vpc_id" {}
variable "subnets" {
  type = list(string)
}
variable "alb_sg_id" {}
variable "tg_arns" {
  type = map(string)
}
