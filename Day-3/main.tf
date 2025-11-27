resource "aws_s3_bucket" "day3-bucket" {
  bucket = "day3-bucket-tanseer"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}