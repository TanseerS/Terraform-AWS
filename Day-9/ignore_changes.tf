resource "random_id" "ignore_suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "ignore_example" {
  bucket = lower("${var.instance_prefix}-ignore-${random_id.ignore_suffix.hex}")

  tags = {
    Name        = "ignore-example"
    Environment = var.environment
  }

  lifecycle {
    # Ignore tag changes so modifying tags doesn't trigger updates
    ignore_changes = ["tags"]
  }
}
