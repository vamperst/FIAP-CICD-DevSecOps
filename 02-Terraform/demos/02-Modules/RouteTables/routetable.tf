resource "aws_route_table" "to-igw" {
  vpc_id = "${data.aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${data.aws_internet_gateway.igw.id}"
  }

  tags = {
    Name = "to-igw-${var.project}"
    env  = "${var.env}"
  }
}
