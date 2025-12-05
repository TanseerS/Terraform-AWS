variable "project_name" {
  type    = string
  default = "Project ALPHA Resource"
}

variable "default_tags" {
  type = map(string)
  default = {
    Owner = "team-ops"
    Env   = "dev"
  }
}

variable "env_tags" {
  type = map(string)
  default = {
    Env = "staging"
  }
}

variable "raw_bucket" {
  type    = string
  default = "My App_Bucket 2025"
}

variable "ports_csv" {
  type    = string
  default = "80,443,8080"
}

variable "environment" {
  type    = string
  default = "dev"
}
