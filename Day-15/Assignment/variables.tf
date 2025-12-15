variable "region" {
  description = "AWS region for all VPCs"
  type        = string
  default     = "us-east-1"
}

variable "vpc_a_cidr" {
  description = "CIDR block for VPC A"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_b_cidr" {
  description = "CIDR block for VPC B"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_c_cidr" {
  description = "CIDR block for VPC C"
  type        = string
  default     = "10.2.0.0/16"
}

variable "subnet_a_cidr" {
  description = "CIDR block for subnet in VPC A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_b_cidr" {
  description = "CIDR block for subnet in VPC B"
  type        = string
  default     = "10.1.1.0/24"
}

variable "subnet_c_cidr" {
  description = "CIDR block for subnet in VPC C"
  type        = string
  default     = "10.2.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = ""
}