<<<<<<< HEAD
resource "aws_subnet" "dev_subnet_public_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.20.4.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "dev_subnet_public_1"
  }
}
=======
resource "aws_subnet" "dev_subnet_public_1" {
  vpc_id                  = aws_vpc.dev_vpc.id
  cidr_block              = "10.20.4.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name                               = "dev_subnet_public_1"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
>>>>>>> 8268c6b (added files)
