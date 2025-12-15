terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-piyushsachdeva"
    key    = "lessons/day17/terraform.tfstate"
    region = "ap-south-1"
  }
}