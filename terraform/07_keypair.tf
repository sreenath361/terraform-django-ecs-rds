resource "tls_private_key" "dev_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "production" {
  key_name   = "${var.ecs_cluster_name}_key_pair"
  public_key = tls_private_key.dev_key.public_key_openssh

  provisioner "local-exec" {    # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOT
      echo '${tls_private_key.dev_key.private_key_pem}' > ./'${var.ecs_cluster_name}'.pem
      chmod 400 ./'${var.ecs_cluster_name}'.pem
    EOT
  }

}
