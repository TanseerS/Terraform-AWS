output "vpc_name" {
  description = "The Name tag applied to the VPC"
  value       = aws_vpc.main.tags["Name"]
}

output "deployment_summary" {
  description = "Summary of environment, instance count and Name tag"
  value = {
    environment    = var.environment
    instance_count = var.instance_count
    name_tag       = var.tags["Name"]
  }
}
