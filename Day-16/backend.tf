terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-tanseerkhan"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }
}