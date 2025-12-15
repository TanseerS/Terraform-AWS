variable "aws_region" {
  description = "AWS region for deployment"
  type        = string
  default     = "us-east-1"
}

variable "app_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
  default     = "my-app-bluegreen"
}

variable "environment_blue" {
  description = "Name of the blue environment"
  type        = string
  default     = "blue"
}

variable "environment_green" {
  description = "Name of the green environment"
  type        = string
  default     = "green"
}

variable "instance_type" {
  description = "EC2 instance type for Elastic Beanstalk"
  type        = string
  default     = "t3.micro"
}

variable "min_instances" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "max_instances" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}

variable "app_version_blue" {
  description = "Application version for blue environment"
  type        = string
  default     = "v1.0"
}

variable "app_version_green" {
  description = "Application version for green environment"
  type        = string
  default     = "v2.0"
}