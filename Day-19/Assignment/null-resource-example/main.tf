resource "null_resource" "setup" {
  provisioner "local-exec" {
    command = "echo 'Setting up local environment...' && mkdir -p logs && echo 'Setup complete' > logs/setup.log"
  }
}

resource "null_resource" "validate" {
  depends_on = [null_resource.setup]

  provisioner "local-exec" {
    command = "echo 'Validating setup...' && cat logs/setup.log"
  }
}

resource "null_resource" "cleanup" {
  depends_on = [null_resource.validate]

  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Cleaning up...' && rm -rf logs/"
  }
}