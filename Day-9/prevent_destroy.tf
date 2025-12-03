resource "random_id" "prevent_suffix" {
  byte_length = 2
}

resource "aws_s3_bucket" "prevent_example" {
  bucket = lower("${var.instance_prefix}-prevent-${random_id.prevent_suffix.hex}")

  tags = {
    Name        = "prevent-example"
    Environment = var.environment
  }

  lifecycle {
    # Prevent this resource from being destroyed by Terraform
    prevent_destroy = true
  }
}
