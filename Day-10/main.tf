// Day-10: Conditional Expression, Dynamic Block, Splat Expression

resource "random_id" "suffix" {
  byte_length = 2
}

// Conditional expression: create buckets only if enable_buckets is true
resource "aws_s3_bucket" "buckets" {
  count = var.enable_buckets ? var.bucket_count : 0

  bucket = lower("day10-bucket-${count.index}-${random_id.suffix.hex}")

  tags = {
    Environment = var.environment
  }
}

// Dynamic block: add tags from bucket_tags list
resource "aws_s3_bucket" "dynamic_tags" {
  count = var.enable_buckets ? var.bucket_count : 0

  bucket = lower("day10-tags-${count.index}-${random_id.suffix.hex}")

  dynamic "tags" {
    for_each = var.bucket_tags[count.index]
    content {
      tags = merge(tags.value, { Environment = var.environment })
    }
  }
}

// Splat expression: extract all bucket ids
locals {
  bucket_ids = aws_s3_bucket.buckets[*].id
}
