data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [var.web_security_group_id]
  subnet_id              = var.public_subnet_id

  user_data = templatefile("${path.module}/templates/user_data.sh", {
    rds_endpoint = var.rds_endpoint
    db_username  = var.db_username
    db_password  = var.db_password
    db_name      = var.db_name
  })

  associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-${var.environment}-web-server"
  }
}