resource "random_id" "trigger_suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "replace_example" {
  bucket = lower("${var.instance_prefix}-replace-${random_id.trigger_suffix.hex}")

  tags = {
    Name        = "replace-example"
    Environment = var.environment
  }

  lifecycle {
    # If the referenced resource changes, force replacement of this resource
    replace_triggered_by = [random_id.trigger_suffix]
  }
}
