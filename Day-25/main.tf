resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "example" {
  ami           = "ami-0abcdef1234567890"  
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "example" {
  bucket = "my-demo-bucket"
}