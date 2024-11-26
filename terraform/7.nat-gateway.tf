resource "aws_eip" "nat_eip" {

}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.dev_subnet_public_1.id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = [aws_internet_gateway.dev_public_igw]
}
