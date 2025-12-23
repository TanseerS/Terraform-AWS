output "upload_bucket_name" {
  description = "Name of the S3 bucket for uploading images"
  value       = aws_s3_bucket.upload_bucket.id
}

output "processed_bucket_name" {
  description = "Name of the S3 bucket for processed images"
  value       = aws_s3_bucket.processed_bucket.id
}

output "website_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.website_bucket.id
}

output "website_url" {
  description = "URL of the static website"
  value       = aws_s3_bucket_website_configuration.website_bucket.website_endpoint
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.image_processor.function_name
}

output "api_gateway_url" {
  description = "URL of the API Gateway"
  value       = aws_api_gateway_deployment.image_api_deployment.invoke_url
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}