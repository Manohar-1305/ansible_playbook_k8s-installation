
output "bastion_public_ip" {
  description = "The Bastion Instance Public IP"
  value       = aws_instance.bastion.public_ip
}

