terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-piyushsachdeva"
    key    = "lessons/day15-assignment/terraform.tfstate"
    region = "ap-south-1"
  }
}