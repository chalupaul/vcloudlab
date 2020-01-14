output "ssh_private_key" {
  value = "${tls_private_key.ssh_key.private_key_pem}"
}

output "esxi1_dns" {
  value = "${aws_instance.esxi1.public_dns}"
}
