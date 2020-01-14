provider "aws" {
  region = var.region
}

resource "random_string" "ssh_key_name" {
  length  = 8
  special = false
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh_key_pair" {
  key_name   = "${var.stage}-${random_string.ssh_key_name.result}"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "linux" {
  name = "${var.stage}-vcloud-ingress"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
