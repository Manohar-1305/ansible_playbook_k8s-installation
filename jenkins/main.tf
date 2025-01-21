provider "aws" {
  region = "ap-south-1" # Correct region code for Asia South (Mumbai)
}

# Fetch the existing VPC by name
data "aws_vpc" "selected_vpc" {
  filter {
    name   = "tag:Name"
    values = ["Hosting-VPC"]
  }
}

# Fetch the existing subnet by name
data "aws_subnet" "selected_subnet" {
  filter {
    name   = "tag:Name"
    values = ["Hosting-Public-1"]
  }
  vpc_id = data.aws_vpc.selected_vpc.id
}

# Fetch the existing security group by name
data "aws_security_group" "selected_sg" {
  filter {
    name   = "group-name"
    values = ["Hosting-VPC-SG"]
  }
  vpc_id = data.aws_vpc.selected_vpc.id
}


# Kubernetes instance
resource "aws_instance" "Jenkins" {
  ami                    = "ami-03bb6d83c60fc5f7c"
  instance_type          = "t2.medium"
  key_name               = "testing-dev-1"
  subnet_id              = data.aws_subnet.selected_subnet.id
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  user_data              = file("kube-containerd-install.sh")

  tags = {
    Name                               = "Jenkins"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
resource "aws_instance" "Sonarqube" {
  ami                    = "ami-03bb6d83c60fc5f7c"
  instance_type          = "t2.medium"
  key_name               = "testing-dev-1"
  subnet_id              = data.aws_subnet.selected_subnet.id
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  user_data              = file("sonarqube.sh")

  tags = {
    Name                               = "Sonarqube"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}
resource "aws_instance" "nexus" {
  ami                    = "ami-03bb6d83c60fc5f7c"
  instance_type          = "t2.medium"
  key_name               = "testing-dev-1"
  subnet_id              = data.aws_subnet.selected_subnet.id
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  user_data              = file("nexus.sh")


  tags = {
    Name                               = "nexus"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

# Outputs for the public IPs
output "Jenkins_public_ip" {
  description = "The Public IP address of the Jenkins instance"
  value       = aws_instance.Jenkins.public_ip
}
output "Sonarqube_public_ip" {
  description = "The Public IP address of the Sonarqube instance"
  value       = aws_instance.Sonarqube.public_ip
}
output "Nexus_public_ip" {
  description = "The Public IP address of the Nexus instance"
  value       = aws_instance.nexus.public_ip
}
