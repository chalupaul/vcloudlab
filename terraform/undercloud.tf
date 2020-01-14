data "aws_ami" "centos7" {
  owners      = ["679593333241"]
  most_recent = true

    filter {
        name   = "name"
        values = ["CentOS Linux 7 x86_64 HVM EBS *"]
    }

    filter {
        name   = "architecture"
        values = ["x86_64"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
}

resource "aws_instance" "esxi1" {
  ami = data.aws_ami.centos7.id
  instance_type = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.linux.id}"]
  key_name = aws_key_pair.ssh_key_pair.key_name
  root_block_device {
    delete_on_termination = true
  }
  tags = {
    name = "${var.stage}-esxi1"
  }
  connection {
    host = aws_instance.esxi1.public_ip
    type = "ssh"
    user = "centos"
    private_key = tls_private_key.ssh_key.private_key_pem
  }
}
