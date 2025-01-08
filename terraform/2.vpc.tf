
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name                               = "dev_vpc"
    "kubernetes.io/cluster/kubernetes" = "owned"

  }
}

resource "aws_internet_gateway" "dev_public_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name                               = "dev_public_igw"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}


