variable "bucket_names" {
  type        = set(string)
  description = "Set of S3 bucket names to create"
  default     = ["output-bucket-1", "output-bucket-2", "output-bucket-3"]
}
