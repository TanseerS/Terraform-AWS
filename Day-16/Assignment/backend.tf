terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-tanseerkhan"
    key    = "lessons/day16-assignment/terraform.tfstate"
    region = "ap-south-1"
  }
}