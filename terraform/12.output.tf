
output "bastion_public_ip" {
  description = "The Bastion Instance Public IP"
  value       = aws_instance.Bastion.public_ip
}
# output "NFS_public_ip" {
#   description = "The Load Balancer Instance Public IP"
#   value       = aws_instance.nfs_server.public_ip
# }

