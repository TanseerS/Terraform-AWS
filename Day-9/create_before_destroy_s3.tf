resource "random_id" "cbd_suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "cbd_example" {
  bucket = lower("${var.instance_prefix}-cbd-${random_id.cbd_suffix.hex}")

  tags = {
    Name        = "cbd-example"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}
