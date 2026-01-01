output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "web_server_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.ec2.web_server_public_ip
}

output "web_server_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = module.ec2.web_server_public_dns
}

output "application_url" {
  description = "URL to access the Flask application"
  value       = "http://${module.ec2.web_server_public_dns}"
}

output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.rds_endpoint
}

output "rds_port" {
  description = "RDS instance port"
  value       = module.rds.rds_port
}

output "database_name" {
  description = "Name of the database"
  value       = var.db_name
}