
resource "aws_route_table_association" "dev_private_route" {
  subnet_id      = aws_subnet.dev_subnet_private_1.id
  route_table_id = aws_route_table.private_route_table.id

}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name                               = "private_route_table"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

