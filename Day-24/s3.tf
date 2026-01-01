resource "aws_s3_bucket" "logs" {
  bucket_prefix = "django-logs-"
}

resource "aws_s3_bucket_versioning" "logs" {
  bucket = aws_s3_bucket.logs.id
  versioning_configuration {
    status = "Enabled"
  }
}