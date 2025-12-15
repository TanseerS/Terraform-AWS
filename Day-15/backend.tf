terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-tanseerkhan"
    key    = "lessons/day15/terraform.tfstate"
    region = "ap-south-1"
  }
}