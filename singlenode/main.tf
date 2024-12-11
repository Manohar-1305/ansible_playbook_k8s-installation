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

# Fetch the existing IAM instance profile
data "aws_iam_instance_profile" "s3-access-profile" {
  name = "s3-access-profile"
}

# Kubernetes instance
resource "aws_instance" "k8s_instance" {
  ami                    = "ami-03bb6d83c60fc5f7c"
  instance_type          = "t2.medium"
  key_name               = "testing-dev-1"
  subnet_id              = data.aws_subnet.selected_subnet.id
  iam_instance_profile   = data.aws_iam_instance_profile.s3-access-profile.name
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  user_data              = file("kube-containerd-install.sh")

  tags = {
    Name                               = "k8s-instance"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }
}

# Delay resource: Introduce a 3-minute (180-second) pause after k8s_instance creation
resource "null_resource" "delay_between_instances" {
  provisioner "local-exec" {
    command = "sleep 120"
  }

  depends_on = [aws_instance.k8s_instance]
}

# Node instance: Created after delay
resource "aws_instance" "node" {
  ami                    = "ami-03bb6d83c60fc5f7c"
  instance_type          = "t2.medium"
  key_name               = "testing-dev-1"
  subnet_id              = data.aws_subnet.selected_subnet.id
  iam_instance_profile   = data.aws_iam_instance_profile.s3-access-profile.name
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  user_data              = file("nfs-setup.sh")

  tags = {
    Name                               = "node"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }

  depends_on = [null_resource.delay_between_instances] # Ensures that the node waits for k8s_instance creation
}

# NFS instance: Created after delay
resource "aws_instance" "nfs" {
  ami                    = "ami-03bb6d83c60fc5f7c"
  instance_type          = "t2.medium"
  key_name               = "testing-dev-1"
  subnet_id              = data.aws_subnet.selected_subnet.id
  iam_instance_profile   = data.aws_iam_instance_profile.s3-access-profile.name
  vpc_security_group_ids = [data.aws_security_group.selected_sg.id]
  user_data              = file("nfs-setup.sh")

  tags = {
    Name                               = "nfs"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }

  depends_on = [null_resource.delay_between_instances] # Ensures that the NFS waits for k8s_instance creation
}

# Outputs for the public IPs
output "k8s_instance_public_ip" {
  description = "The public IP address of the Kubernetes instance"
  value       = aws_instance.k8s_instance.public_ip
}

output "node_public_ip" {
  description = "The public IP address of the Node instance"
  value       = aws_instance.node.public_ip
}

output "nfs_public_ip" {
  description = "The public IP address of the NFS instance"
  value       = aws_instance.nfs.public_ip
}
