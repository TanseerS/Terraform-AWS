variable "region" {
  type    = string
  default = "us-east-1"
}

// Identify VPC: prefer explicit id, fallback to tag
variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_tag" {
  type    = string
  default = ""
}

// Identify Subnet: prefer explicit id, fallback to tag or first subnet in VPC
variable "subnet_id" {
  type    = string
  default = ""
}

variable "subnet_tag" {
  type    = string
  default = ""
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
