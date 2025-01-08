
resource "aws_subnet" "dev_subnet_private_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.20.5.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name                               = "dev_subnet_private_1"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

