resource "random_id" "cond_suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "cond_example" {
  bucket = lower("${var.instance_prefix}-cond-${random_id.cond_suffix.hex}")

  tags = {
    Name        = "cond-example"
    Environment = var.environment
  }
}
