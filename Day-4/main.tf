resource "aws_s3_bucket" "day4_bucket" {
  bucket = "day4-bucket-tanseer"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}