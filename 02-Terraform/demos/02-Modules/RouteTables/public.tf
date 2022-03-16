
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

resource "aws_route_table_association" "public_association" {
  for_each       = data.aws_subnet.public
  subnet_id      = "${each.value.id}"
  route_table_id = "${aws_route_table.to-igw.id}"
}


output "subnet_qtd_public" {
  value      = "${length(data.aws_subnet.public.*)}"
}

output "subnet_cidr_blocks_public" {
  value = ["${data.aws_subnet.public.*}"]
}