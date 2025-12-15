# VPC A
resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_a_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "VPC-A"
    Environment = "Demo"
    Purpose     = "Transitive-Peering-Demo"
  }
}

# VPC B
resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_b_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "VPC-B"
    Environment = "Demo"
    Purpose     = "Transitive-Peering-Demo"
  }
}

# VPC C
resource "aws_vpc" "vpc_c" {
  cidr_block           = var.vpc_c_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "VPC-C"
    Environment = "Demo"
    Purpose     = "Transitive-Peering-Demo"
  }
}

# Subnet in VPC A
resource "aws_subnet" "subnet_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = var.subnet_a_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Subnet-A"
    Environment = "Demo"
  }
}

# Subnet in VPC B
resource "aws_subnet" "subnet_b" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = var.subnet_b_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Subnet-B"
    Environment = "Demo"
  }
}

# Subnet in VPC C
resource "aws_subnet" "subnet_c" {
  vpc_id                  = aws_vpc.vpc_c.id
  cidr_block              = var.subnet_c_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Subnet-C"
    Environment = "Demo"
  }
}

# Internet Gateway for VPC A
resource "aws_internet_gateway" "igw_a" {
  vpc_id = aws_vpc.vpc_a.id

  tags = {
    Name        = "IGW-A"
    Environment = "Demo"
  }
}

# Internet Gateway for VPC B
resource "aws_internet_gateway" "igw_b" {
  vpc_id = aws_vpc.vpc_b.id

  tags = {
    Name        = "IGW-B"
    Environment = "Demo"
  }
}

# Internet Gateway for VPC C
resource "aws_internet_gateway" "igw_c" {
  vpc_id = aws_vpc.vpc_c.id

  tags = {
    Name        = "IGW-C"
    Environment = "Demo"
  }
}

# Route table for VPC A
resource "aws_route_table" "rt_a" {
  vpc_id = aws_vpc.vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_a.id
  }

  tags = {
    Name        = "Route-Table-A"
    Environment = "Demo"
  }
}

# Route table for VPC B
resource "aws_route_table" "rt_b" {
  vpc_id = aws_vpc.vpc_b.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_b.id
  }

  tags = {
    Name        = "Route-Table-B"
    Environment = "Demo"
  }
}

# Route table for VPC C
resource "aws_route_table" "rt_c" {
  vpc_id = aws_vpc.vpc_c.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_c.id
  }

  tags = {
    Name        = "Route-Table-C"
    Environment = "Demo"
  }
}

# Associate route tables with subnets
resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_a.id
}

resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_b.id
}

resource "aws_route_table_association" "rta_c" {
  subnet_id      = aws_subnet.subnet_c.id
  route_table_id = aws_route_table.rt_c.id
}

# Transit Gateway
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway for transitive peering demo"

  tags = {
    Name        = "Transitive-TGW"
    Environment = "Demo"
  }
}

# Transit Gateway VPC Attachment for VPC A
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_a" {
  subnet_ids         = [aws_subnet.subnet_a.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_a.id

  tags = {
    Name = "TGW-Attach-A"
  }
}

# Transit Gateway VPC Attachment for VPC B
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_b" {
  subnet_ids         = [aws_subnet.subnet_b.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_b.id

  tags = {
    Name = "TGW-Attach-B"
  }
}

# Transit Gateway VPC Attachment for VPC C
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach_c" {
  subnet_ids         = [aws_subnet.subnet_c.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.vpc_c.id

  tags = {
    Name = "TGW-Attach-C"
  }
}

# Transit Gateway Route Table
resource "aws_ec2_transit_gateway_route_table" "tgw_rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "TGW-Route-Table"
  }
}

# Associate attachments with route table
resource "aws_ec2_transit_gateway_route_table_association" "assoc_a" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attach_a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc_b" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attach_b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "assoc_c" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attach_c.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

# Propagate routes (this makes it transitive)
resource "aws_ec2_transit_gateway_route_table_propagation" "prop_a" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attach_a.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "prop_b" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attach_b.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

resource "aws_ec2_transit_gateway_route_table_propagation" "prop_c" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attach_c.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw_rt.id
}

# Add routes to VPC route tables for TGW
resource "aws_route" "route_a_to_tgw" {
  route_table_id         = aws_route_table.rt_a.id
  destination_cidr_block = "10.1.0.0/16"  # To VPC B
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "route_a_to_tgw_c" {
  route_table_id         = aws_route_table.rt_a.id
  destination_cidr_block = "10.2.0.0/16"  # To VPC C
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "route_b_to_tgw_a" {
  route_table_id         = aws_route_table.rt_b.id
  destination_cidr_block = "10.0.0.0/16"  # To VPC A
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "route_b_to_tgw_c" {
  route_table_id         = aws_route_table.rt_b.id
  destination_cidr_block = "10.2.0.0/16"  # To VPC C
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "route_c_to_tgw_a" {
  route_table_id         = aws_route_table.rt_c.id
  destination_cidr_block = "10.0.0.0/16"  # To VPC A
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

resource "aws_route" "route_c_to_tgw_b" {
  route_table_id         = aws_route_table.rt_c.id
  destination_cidr_block = "10.1.0.0/16"  # To VPC B
  transit_gateway_id     = aws_ec2_transit_gateway.tgw.id
}

# Security Groups
resource "aws_security_group" "sg_a" {
  name        = "sg-a"
  description = "Security group for VPC A"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from other VPCs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.1.0.0/16", "10.2.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-A"
  }
}

resource "aws_security_group" "sg_b" {
  name        = "sg-b"
  description = "Security group for VPC B"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from other VPCs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16", "10.2.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-B"
  }
}

resource "aws_security_group" "sg_c" {
  name        = "sg-c"
  description = "Security group for VPC C"
  vpc_id      = aws_vpc.vpc_c.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ICMP from other VPCs"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/16", "10.1.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG-C"
  }
}

# EC2 Instances
resource "aws_instance" "instance_a" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_a.id
  vpc_security_group_ids = [aws_security_group.sg_a.id]
  key_name               = var.key_name
  user_data              = local.user_data_a

  tags = {
    Name = "Instance-A"
  }
}

resource "aws_instance" "instance_b" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_b.id
  vpc_security_group_ids = [aws_security_group.sg_b.id]
  key_name               = var.key_name
  user_data              = local.user_data_b

  tags = {
    Name = "Instance-B"
  }
}

resource "aws_instance" "instance_c" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.subnet_c.id
  vpc_security_group_ids = [aws_security_group.sg_c.id]
  key_name               = var.key_name
  user_data              = local.user_data_c

  tags = {
    Name = "Instance-C"
  }
}