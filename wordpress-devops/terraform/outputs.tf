# EC2 public IP
output "public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.wordpress.public_ip
}

# EC2 public DNS
output "public_dns" {
  description = "Public DNS name of the EC2 instance"
  value       = aws_instance.wordpress.public_dns
}

# EC2 instance ID
output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.wordpress.id
}

# VPC ID
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

# Public subnet ID
output "subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

# Security group ID
output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.wordpress.id
}