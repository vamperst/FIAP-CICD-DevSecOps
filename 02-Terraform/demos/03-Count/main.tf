# Specify the provider and access details
provider "aws" {
  region = "${var.aws_region}"
}

variable "project" {
  default = "fiap-lab"
}

data "aws_vpc" "vpc" {
  tags = {
    Name = "${var.project}"
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "tag:Tier"
    values = ["Public"]
  }
  filter {
    name   = "vpc-id"
    values = ["${data.aws_vpc.vpc.id}"]
  }
}

data "aws_subnet" "public" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}


resource "random_shuffle" "random_subnet" {
  input        = [for s in data.aws_subnet.public : s.id]
  result_count = 1
}

resource "aws_elb" "web" {
  name = "terraform-example-elb"

  subnets         = data.aws_subnets.all.ids
  security_groups = ["${aws_security_group.allow-ssh.id}"]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 6
  }

  # The instances are registered automatically
  instances = aws_instance.web.*.id
}

resource "aws_instance" "web" {
  instance_type = "t3.micro"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"

  count = 2

  subnet_id              = "${random_shuffle.random_subnet.result[0]}"
  vpc_security_group_ids = ["${aws_security_group.allow-ssh.id}"]
  key_name               = "${var.KEY_NAME}"

  provisioner "file" {
    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/script.sh",
      "sudo /tmp/script.sh",
    ]
  }

  connection {
    user        = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_KEY}")}"
    host = "${self.public_dns}"
  }

  tags = {
    Name = "${format("nginx-%03d", count.index + 1)}"
  }
}
