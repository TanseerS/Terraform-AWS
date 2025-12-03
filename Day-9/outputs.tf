output "instance_id" {
  description = "The EC2 instance id created by this demo"
  value       = aws_instance.example.id
}

output "instance_name" {
  description = "The Name tag of the EC2 instance"
  value       = aws_instance.example.tags["Name"]
}

output "instance_public_ip" {
  description = "Public IP of the instance (if assigned)"
  value       = try(aws_instance.example.public_ip, "")
}
