output "ec2_dns" {
  value = "${aws_instance.example.*.public_ip}"
}
