variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "backup_name" {
  type    = string
  default = "daily-bak"
}

variable "backup_password" {
  type      = string
  sensitive = true
  default   = "changeme"
}

variable "config_path" {
  type    = string
  default = "./config.json"
}

variable "regions_a" {
  type    = list(string)
  default = ["us-east-1", "eu-west-1"]
}

variable "regions_b" {
  type    = list(string)
  default = ["eu-west-1", "ap-south-1"]
}

variable "costs" {
  type    = list(number)
  default = [100.0, 250.5, -20.0]
}

variable "credits" {
  type    = list(number)
  default = [50.0]
}

variable "json_config_path" {
  type    = string
  default = "./config.json"
}

variable "environment" {
  type    = string
  default = "dev"
}
