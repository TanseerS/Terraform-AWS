output "vpc_a_id" {
  description = "ID of VPC A"
  value       = aws_vpc.vpc_a.id
}

output "vpc_b_id" {
  description = "ID of VPC B"
  value       = aws_vpc.vpc_b.id
}

output "vpc_c_id" {
  description = "ID of VPC C"
  value       = aws_vpc.vpc_c.id
}

output "transit_gateway_id" {
  description = "ID of the Transit Gateway"
  value       = aws_ec2_transit_gateway.tgw.id
}

output "instance_a_id" {
  description = "ID of Instance A"
  value       = aws_instance.instance_a.id
}

output "instance_b_id" {
  description = "ID of Instance B"
  value       = aws_instance.instance_b.id
}

output "instance_c_id" {
  description = "ID of Instance C"
  value       = aws_instance.instance_c.id
}

output "instance_a_private_ip" {
  description = "Private IP of Instance A"
  value       = aws_instance.instance_a.private_ip
}

output "instance_b_private_ip" {
  description = "Private IP of Instance B"
  value       = aws_instance.instance_b.private_ip
}

output "instance_c_private_ip" {
  description = "Private IP of Instance C"
  value       = aws_instance.instance_c.private_ip
}

output "instance_a_public_ip" {
  description = "Public IP of Instance A"
  value       = aws_instance.instance_a.public_ip
}

output "instance_b_public_ip" {
  description = "Public IP of Instance B"
  value       = aws_instance.instance_b.public_ip
}

output "instance_c_public_ip" {
  description = "Public IP of Instance C"
  value       = aws_instance.instance_c.public_ip
}

output "test_transitive_connectivity_command" {
  description = "Command to test transitive connectivity between VPCs"
  value       = <<-EOT
    To test transitive peering connectivity via Transit Gateway:
    1. SSH into Instance A: ssh -i your-key.pem ec2-user@${aws_instance.instance_a.public_ip}
    2. Ping Instance B: ping ${aws_instance.instance_b.private_ip}
    3. Ping Instance C: ping ${aws_instance.instance_c.private_ip} (transitive)
    
    Similarly, test from B to A and C, and C to A and B.
  EOT
}