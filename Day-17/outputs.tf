output "application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = aws_elastic_beanstalk_application.app.name
}

output "blue_environment_url" {
  description = "URL of the Blue environment"
  value       = aws_elastic_beanstalk_environment.blue.endpoint_url
}

output "green_environment_url" {
  description = "URL of the Green environment"
  value       = aws_elastic_beanstalk_environment.green.endpoint_url
}

output "blue_environment_name" {
  description = "Name of the Blue environment"
  value       = aws_elastic_beanstalk_environment.blue.name
}

output "green_environment_name" {
  description = "Name of the Green environment"
  value       = aws_elastic_beanstalk_environment.green.name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket for application versions"
  value       = aws_s3_bucket.app_versions.bucket
}

output "instructions" {
  description = "Instructions for using the blue-green deployment"
  value = <<-EOT
    Blue-Green Deployment Demo Instructions:

    1. Blue Environment (Production - v1.0): ${aws_elastic_beanstalk_environment.blue.endpoint_url}
    2. Green Environment (Staging - v2.0): ${aws_elastic_beanstalk_environment.green.endpoint_url}

    To perform a blue-green swap:
    aws elasticbeanstalk swap-environment-cnames \
      --source-environment-name ${aws_elastic_beanstalk_environment.blue.name} \
      --destination-environment-name ${aws_elastic_beanstalk_environment.green.name} \
      --region ${var.aws_region}

    Or use the swap-environments.ps1 script (on Windows) or adapt for bash.
  EOT
}