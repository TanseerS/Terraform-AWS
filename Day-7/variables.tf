variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"

  validation {
    condition     = contains(var.allowed_region, var.region)
    error_message = "region must be one of the allowed_region values"
  }
}

variable "instance_count" {
  type        = number
  description = "Number of EC2 instances to create"
  default     = 1
}

variable "monitoring_enabled" {
  type    = bool
  default = true
}

variable "associate_public_ip" {
  type    = bool
  default = true
}

variable "cidr_block" {
  type    = list(string)
  default = ["10.0.0.0/8", "192.168.0.0/16", "172.16.0.0/12"]
}

variable "allowed_vm_types" {
  type    = list(string)
  default = ["t2.micro", "t2.small", "t3.micro", "t3.small"]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"

  validation {
    condition     = contains(var.allowed_vm_types, var.instance_type)
    error_message = "instance_type must be one of the allowed_vm_types"
  }
}

variable "allowed_region" {
  type    = set(string)
  default = ["us-east-1", "us-west-2", "eu-west-1"]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-Instance"
    created_by  = "terraform"
  }
}

variable "ingress_values" {
  type    = tuple([number, string, number])
  default = [443, "tcp", 443]
}

variable "config" {
  type = object({
    region         = string
    monitoring     = bool
    instance_count = number
  })

  default = {
    region         = "us-east-1"
    monitoring     = true
    instance_count = 1
  }
}
