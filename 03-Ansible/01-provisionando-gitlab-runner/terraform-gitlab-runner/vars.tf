
variable "AWS_REGION" {
  default = "us-east-1"
}
variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-0e472ba40eb589f49"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}
variable "project" {
  default = "fiap-lab"
}
variable "KEY_NAME" {
  default = "vockey"
}
variable "PATH_TO_KEY" {
  default = "/home/ubuntu/.ssh/vockey.pem"
}
variable "INSTANCE_USERNAME" {
  default = "ubuntu"
}
