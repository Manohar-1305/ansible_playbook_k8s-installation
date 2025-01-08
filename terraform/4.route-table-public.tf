
resource "aws_route_table" "dev_public_rt" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name                               = "dev_public_rt"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_route" "dev_route_1" {
  route_table_id         = aws_route_table.dev_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dev_public_igw.id
}

resource "aws_route_table_association" "dev_public_route_1" {
  subnet_id      = aws_subnet.dev_subnet_public_1.id
  route_table_id = aws_route_table.dev_public_rt.id
}

