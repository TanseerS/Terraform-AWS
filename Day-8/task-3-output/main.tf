// Task 3: Create S3 buckets to demonstrate output with for expressions
resource "aws_s3_bucket" "buckets" {
  for_each = var.bucket_names
  bucket   = lower("${each.value}")

  tags = {
    Name = each.value
  }
}