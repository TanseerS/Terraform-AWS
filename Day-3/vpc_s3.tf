resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "main-vpc"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "assets" {
  bucket = lower("assets-${random_id.bucket_suffix.hex}")


  tags = {
    Name = "assets-bucket"
    VPC  = aws_vpc.main.id
  }
}
