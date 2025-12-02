// Task 3: Output using for expressions

output "all_bucket_names" {
  description = "All bucket names using a for loop (list)"
  value       = [for bucket in aws_s3_bucket.buckets : bucket.bucket]
}

output "all_bucket_ids" {
  description = "All bucket IDs using a for expression (list)"
  value       = [for bucket in aws_s3_bucket.buckets : bucket.id]
}

output "bucket_names_and_ids" {
  description = "Both bucket names and IDs in a map using for expression"
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    bucket.bucket => bucket.id
  }
}

output "bucket_info_formatted" {
  description = "Formatted bucket information using for expression"
  value = [
    for key, bucket in aws_s3_bucket.buckets :
    "Bucket: ${bucket.bucket}, ID: ${bucket.id}, Name Tag: ${key}"
  ]
}
