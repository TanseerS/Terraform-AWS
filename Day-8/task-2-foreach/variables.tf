variable "bucket_names" {
  type        = set(string)
  description = "Set of unique S3 bucket names to create using for_each"
  default     = ["foreach-bucket-1", "foreach-bucket-2"]
}
