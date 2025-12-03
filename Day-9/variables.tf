variable "environment" {
  type    = string
  default = "dev"
}
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "instance_prefix" {
  type        = string
  description = "Prefix used when naming the demo EC2 instance (tag Name)"
  default     = "cbdemo"
}

// Ensure instance_prefix is not empty (works with older Terraform versions)
variable "instance_prefix_validation" {
  type    = string
  default = ""
  validation {
    condition     = var.instance_prefix != ""
    error_message = "instance_prefix must not be empty"
  }
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
