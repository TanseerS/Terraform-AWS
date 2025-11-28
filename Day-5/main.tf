variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

resource "aws_s3_bucket" "demo" {
    bucket = "deployebucketdemo"
    
    tags = {
        Name        = "Deploye Bucket"
        Environment = var.environment
    }
  
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.demo.bucket
}