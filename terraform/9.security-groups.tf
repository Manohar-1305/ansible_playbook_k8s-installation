<<<<<<< HEAD
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow ssh"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow_tls"
  }
}

resource "aws_security_group" "Web-traffic" {
  name        = "Web-traffic"
  description = "Allow HTTP and HTPPS "
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow port 443"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow_HTTP-HTTPS"
  }
}

resource "aws_security_group" "kubernetes" {
  name        = "Kubernetes"
  description = "Allow kubernetes API server, kubelet, etcd"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow port 6443"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow kubelet communiction"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow kubelet communiction"
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow kubelet communiction"
    from_port   = 10252
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow_kubernetes_components"
  }
}
resource "aws_security_group" "nat_gateway_sg" {
  name        = "NAS-GATEWAY-SG"
  description = "Allow NAT GARTEWAY"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow inbound traffic from VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Allow_nat_gateway_components"
  }
}

resource "aws_security_group" "open_access_within_vpc" {
  name        = "open_access_within_vpc"
  description = "security group to open access within vpc"
  vpc_id      = aws_vpc.dev_vpc.id
  ingress {
    description = "Allow inbound traffic within VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    description = "Allow  Outbound within vpc"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }
  tags = {
    Name = "open_access_vpc_security_Group"
  }
}

resource "aws_security_group" "haproxy-sg" {
  name        = "haproxy-sg"
  description = "security group for haproxy server"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow internal health check"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }

  tags = {
    Name = "haproxy_security_Group"
  }
}

resource "aws_security_group" "node_port_group" {
  name        = "my_security_group"
  description = "allow traffic on ports 30000-32767"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["10.20.0.0/16"]
  }
  tags = {
    Name = "node_port_Group"
  }
}
resource "aws_security_group" "nfs" {
  name        = "nfs-sg"
  description = "allow nfs traffic"
  vpc_id      = aws_vpc.dev_vpc.id
  ingress {
    description = "Allow NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "udp"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "nfs_security_Group"
  }
}
resource "aws_security_group" "etcd_sg" {
  name        = "etcd-sg"
  description = "SEcurity Group for etcd"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow etcd client and peer communication"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "etcd_security_Group"
  }
}
=======
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow ssh"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                               = "Allow_tls"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_security_group" "Web-traffic" {
  name        = "Web-traffic"
  description = "Allow HTTP and HTPPS "
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "allow port 443"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                               = "Allow_Http-Https"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_security_group" "kubernetes" {
  name        = "Kubernetes"
  description = "Allow kubernetes API server, kubelet, etcd"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow port 6443"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow kubelet communiction"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow kubelet communiction"
    from_port   = 10251
    to_port     = 10251
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow kubelet communiction"
    from_port   = 10252
    to_port     = 10252
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                               = "Allow_kubernetes_components"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
resource "aws_security_group" "nat_gateway_sg" {
  name        = "NAS-GATEWAY-SG"
  description = "Allow NAT GARTEWAY"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "Allow inbound traffic from VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    description = "Allow Everything Outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                               = "Allow_nat_gateway_components"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_security_group" "open_access_within_vpc" {
  name        = "open_access_within_vpc"
  description = "security group to open access within vpc"
  vpc_id      = aws_vpc.dev_vpc.id
  ingress {
    description = "Allow inbound traffic within VPC CIDR"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    description = "Allow  Outbound within vpc"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.20.0.0/16"]
  }
  tags = {
    Name                               = "open_access_vpc_security_Group"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_security_group" "haproxy-sg" {
  name        = "haproxy-sg"
  description = "security group for haproxy server"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "allow port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow internal health check"
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }

  tags = {
    Name                               = "haproxy_security_Group"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

resource "aws_security_group" "node_port_group" {
  name        = "my_security_group"
  description = "allow traffic on ports 30000-32767"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # Allows all outbound traffic
    cidr_blocks = ["10.20.0.0/16"]
  }
  tags = {
    Name                               = "node_port_Group"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
resource "aws_security_group" "nfs" {
  name        = "nfs-sg"
  description = "allow nfs traffic"
  vpc_id      = aws_vpc.dev_vpc.id
  ingress {
    description = "Allow NFS traffic"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "udp"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                               = "nfs_security_Group"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
resource "aws_security_group" "etcd_sg" {
  name        = "etcd-sg"
  description = "SEcurity Group for etcd"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "allow etcd client and peer communication"
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["10.20.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name                               = "etcd_security_Group"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
>>>>>>> 8268c6b (added files)
