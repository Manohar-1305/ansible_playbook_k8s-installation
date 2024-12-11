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
resource "aws_instance" "Jenkins-server" {
  ami                    = "ami-03bb6d83c60fc5f7c"
  instance_type          = "t2.medium"
  key_name               = "testing-dev-1"
  subnet_id              = data.aws_subnet.selected_subnet.id
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  user_data              = file("kube-containerd-install.sh")

  tags = {
    Name                               = "Jenkins-instance"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

# Outputs for the public IPs
output "Jenkins_public_ip" {
  description = "The public IP address of the Jenkins instance"
  value       = aws_instance.Jenkins-server.public_ip
}
