provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {}
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key" {
  key_name_prefix = "vscode-"
  public_key      = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "ec2_key" {
  filename          = "ec2_key.pem"
  sensitive_content = tls_private_key.ec2_key.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 ${self.filename}"
  }
}

resource "aws_instance" "ec2" {
  depends_on = [local_file.ec2_key]

  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type

  key_name = aws_key_pair.ec2_key.key_name

  vpc_security_group_ids = [
    aws_security_group.demo.id
  ]

  provisioner "remote-exec" {
    inline = ["hostname"]

    // wait for instance to become available
    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = tls_private_key.deploy.private_key_pem
    }
  }

  // run ansible
  provisioner "local-exec" {
    command = "ansible-playbook site.yml"
    environment = {
      PUBLIC_IP = self.public_ip
    }
  }
}