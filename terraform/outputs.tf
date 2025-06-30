output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public.id
}

output "combined_instance_id" {
  description = "The ID of the combined EC2 instance"
  value       = aws_instance.combined.id
}

output "combined_public_ip" {
  description = "The public IP address of the combined EC2 instance"
  value       = aws_eip.combined.public_ip
}

output "combined_public_dns" {
  description = "The public DNS name of the combined EC2 instance"
  value       = aws_eip.combined.public_dns
}

output "frontend_security_group_id" {
  description = "The ID of the frontend security group"
  value       = aws_security_group.frontend.id
}

output "backend_security_group_id" {
  description = "The ID of the backend security group"
  value       = aws_security_group.backend.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
