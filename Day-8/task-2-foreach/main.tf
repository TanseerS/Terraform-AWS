// Task 2: Create S3 buckets using for_each
// Reference bucket names using each.value
resource "aws_s3_bucket" "buckets" {
  for_each = var.bucket_names
  bucket   = lower("${each.value}")

  tags = {
    Name = each.value
    Key  = each.key
  }
}

// Data source to get current AWS account ID for unique naming
data "aws_caller_identity" "current" {}
