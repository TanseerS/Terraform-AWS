// Conditional expression output: show bucket count only if enabled
output "bucket_count" {
  description = "Number of buckets created (conditional)"
  value       = var.enable_buckets ? length(aws_s3_bucket.buckets) : 0
}

// Splat expression output: all bucket names
output "bucket_names" {
  description = "All bucket names (splat)"
  value       = aws_s3_bucket.buckets[*].bucket
}

// Splat expression output: all bucket ids
output "bucket_ids" {
  description = "All bucket ids (splat)"
  value       = aws_s3_bucket.buckets[*].id
}

// Dynamic tags bucket names
output "dynamic_tag_buckets" {
  description = "Buckets with dynamic tags (splat)"
  value       = aws_s3_bucket.dynamic_tags[*].bucket
}
