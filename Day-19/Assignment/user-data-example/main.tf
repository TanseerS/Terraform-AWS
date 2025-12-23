resource "aws_instance" "user_data_example" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>Hello from user_data!</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "user-data-example"
  }
}

output "instance_id" {
  value = aws_instance.user_data_example.id
}

output "public_ip" {
  value = aws_instance.user_data_example.public_ip
}