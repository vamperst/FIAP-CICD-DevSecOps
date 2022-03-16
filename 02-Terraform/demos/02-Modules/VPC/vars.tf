data "aws_availability_zones" "available" {}

variable "project" {
  default = "fiap-lab"
}
variable "vpc_cidr" {
  default = "9.0.0.0/16"
}
variable "subnet_escale" {
  default = 6
}

variable "env" {
  default = "prod"
}

variable "AWS_REGION" {
  default = "us-east-1"
}