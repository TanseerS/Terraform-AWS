// Minimal EC2 demo with create_before_destroy lifecycle

resource "random_id" "suffix" {
  byte_length = 3
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  tags = {
    Name        = "${var.instance_prefix}-${random_id.suffix.hex}"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}
