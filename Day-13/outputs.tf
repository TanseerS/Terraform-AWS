output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.main.id
}

output "instance_private_ip" {
  description = "Private IP address"
  value       = aws_instance.main.private_ip
}

output "vpc_id" {
  description = "VPC ID from data source"
  value       = data.aws_vpc.shared.id
}

output "subnet_id" {
  description = "Subnet ID from data source"
  value       = data.aws_subnet.shared.id
}

output "ami_id" {
  description = "AMI ID used for instance"
  value       = data.aws_ami.amazon_linux_2.id
}
