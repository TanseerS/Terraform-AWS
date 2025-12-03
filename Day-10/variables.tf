variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "enable_buckets" {
  type        = bool
  description = "Enable S3 bucket creation"
  default     = true
}

variable "bucket_count" {
  type        = number
  description = "Number of S3 buckets to create"
  default     = 2
}

variable "bucket_tags" {
  type = list(map(string))
  default = [
    { Name = "bucket-1", Owner = "team-a" },
    { Name = "bucket-2", Owner = "team-b" }
  ]
}
