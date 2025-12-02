// Task 3: Create S3 buckets to demonstrate output with for expressions
resource "aws_s3_bucket" "buckets" {
  for_each = var.bucket_names
  bucket   = lower("${each.value}")

  tags = {
    Name = each.value
  }
}

// Data source to get current AWS account ID for unique naming
data "aws_caller_identity" "current" {}
