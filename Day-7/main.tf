// Random suffix to help make bucket name unique
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

// VPC using first cidr from the cidr_block list
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block[0]

  tags = var.tags
}

// Two subnets using the next two cidr blocks in the list
resource "aws_subnet" "one" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block[1]
}

resource "aws_subnet" "two" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block[2]
}

// Security group with ingress driven by the ingress_values tuple
resource "aws_security_group" "sg" {
  name   = "${var.environment}-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = var.ingress_values[0]
    protocol    = var.ingress_values[1]
    to_port     = var.ingress_values[2]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

// Data source to get a recent Amazon Linux 2 AMI for the region
data "aws_ami" "amazonlinux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

// Task 2 & 3: EC2 instances created using var.instance_count and boolean flags
resource "aws_instance" "counted" {
  count         = var.instance_count
  ami           = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.one.id

  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.monitoring_enabled

  vpc_security_group_ids = [aws_security_group.sg.id]
  tags                   = var.tags
}

// Task 9: Use the config object to drive a separately provisioned set of instances
resource "aws_instance" "from_config" {
  provider      = aws.config
  count         = var.config.instance_count
  ami           = data.aws_ami.amazonlinux.id
  instance_type = var.instance_type

  monitoring = var.config.monitoring

  subnet_id = aws_subnet.two.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags                   = var.tags
}

// Task 1: S3 bucket that uses the environment as a mandatory prefix and references VPC id in tags (implicit dependency)
resource "aws_s3_bucket" "assets" {
  bucket = lower("${var.environment}-assets-${random_id.bucket_suffix.hex}")

  tags = merge(var.tags, {
    VPC = aws_vpc.main.id
  })
}
