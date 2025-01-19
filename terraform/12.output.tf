output "bastion_public_ip" {
  description = "The Bastion Instance Public IP"
  value       = aws_instance.bastion.public_ip
}
output "NFS_public_ip" {
  description = "The Load Balancer Instance Public IP"
  value       = aws_instance.nfs_server.public_ip
}
output "loadbalancer_public_ip" {
  description = "The Load Balancer Instance Public IP"
  value       = aws_instance.load-balancer-server.public_ip
}
