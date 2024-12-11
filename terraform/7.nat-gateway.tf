<<<<<<< HEAD
resource "aws_eip" "nat_eip" {

}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.dev_subnet_public_1.id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = [aws_internet_gateway.dev_public_igw]
}
=======
resource "aws_eip" "nat_eip" {
  tags = {
    "Name" = "nat_eip"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  subnet_id     = aws_subnet.dev_subnet_public_1.id
  allocation_id = aws_eip.nat_eip.id
  depends_on    = [aws_internet_gateway.dev_public_igw]
}

resource "aws_eip" "load_balancer_eip" {
  tags = {
    "Name" = "loadbalancer-eip"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
resource "aws_eip_association" "lb_eip_assoc" {
  instance_id   = aws_instance.load-balancer-server.id
  allocation_id = aws_eip.load_balancer_eip.id
  depends_on    = [aws_instance.load-balancer-server]
}
>>>>>>> 8268c6b (added files)
