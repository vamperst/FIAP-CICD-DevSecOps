
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-087c17d1fe0178315"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}

variable "KEY_NAME" {
  default = "vockey"
}
variable "PATH_TO_KEY" {
  default = "/home/ubuntu/.ssh/vockey.pem"
}
variable "INSTANCE_USERNAME" {
  default = "ec2-user"
}
