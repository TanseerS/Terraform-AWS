resource "aws_instance" "example" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"

  tags = {
    Name = "destroy-provisioner-demo"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Instance ${self.id} is being destroyed at $(date)' >> destroy.log"
  }
}

resource "null_resource" "backup" {
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Performing cleanup backup...' && mkdir -p backup && cp -r * backup/ 2>/dev/null || true"
  }
}