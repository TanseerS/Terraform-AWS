// Task 1: Create S3 buckets using count
// Reference bucket names using count.index
resource "aws_s3_bucket" "buckets" {
  count  = length(var.bucket_names)
  bucket = lower("${var.bucket_names[count.index]}")

  tags = {
    Name  = var.bucket_names[count.index]
    Index = count.index
  }
}