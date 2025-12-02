output "bucket_names" {
  description = "Names of all S3 buckets created with count"
  value       = aws_s3_bucket.buckets[*].bucket
}

output "bucket_count" {
  description = "Total number of buckets created"
  value       = length(aws_s3_bucket.buckets)
}

output "bucket_details" {
  description = "Details of buckets indexed numerically [0], [1]"
  value = {
    bucket_0 = aws_s3_bucket.buckets[0].bucket
    bucket_1 = aws_s3_bucket.buckets[1].bucket
  }
}
