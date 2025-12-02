output "bucket_names" {
  description = "Names of all S3 buckets created with for_each"
  value       = [for bucket in aws_s3_bucket.buckets : bucket.bucket]
}

output "bucket_details" {
  description = "Details of buckets indexed by key: [\"bucket-name\"]"
  value = {
    bucket_1 = aws_s3_bucket.buckets["foreach-bucket-1"].bucket
    bucket_2 = aws_s3_bucket.buckets["foreach-bucket-2"].bucket
  }
}

output "all_bucket_info" {
  description = "All bucket information keyed by name"
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    key => {
      bucket_name = bucket.bucket
      bucket_id   = bucket.id
    }
  }
}
