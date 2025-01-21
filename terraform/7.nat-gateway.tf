
resource "aws_eip" "nat_eip" {

}
resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.dev_subnet_public_1.id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = [aws_internet_gateway.dev_public_igw]
}

resource "aws_eip" "bastion_eip" {
  tags = {
    Name = "bastion_eip"
  }
}
# resource "aws_eip_association" "bastion_eip_assoc" {
#   instance_id   = aws_instance.Bastion.id
#   allocation_id = aws_eip.bastion_eip.id
#   depends_on    = [aws_instance.Bastion]

# }
