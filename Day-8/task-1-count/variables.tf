variable "bucket_names" {
  type        = list(string)
  description = "List of S3 bucket names to create using count"
  default     = ["count-bucket-1", "count-bucket-2"]
}
