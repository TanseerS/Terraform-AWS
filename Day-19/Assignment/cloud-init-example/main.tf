data "template_file" "cloud_init" {
  template = file("${path.module}/cloud-init.yaml")
}

resource "aws_instance" "cloud_init_example" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  user_data = data.template_file.cloud_init.rendered

  tags = {
    Name = "cloud-init-example"
  }
}

output "instance_id" {
  value = aws_instance.cloud_init_example.id
}

output "public_ip" {
  value = aws_instance.cloud_init_example.public_ip
}