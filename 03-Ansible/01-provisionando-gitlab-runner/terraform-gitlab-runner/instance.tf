
resource "random_shuffle" "random_subnet" {
  input        = [for s in data.aws_subnet.public : s.id]
  result_count = 1
}
resource "aws_instance" "example" {
  count=1
  ami = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.micro"
  iam_instance_profile = "LabInstanceProfile"
  key_name = "${var.KEY_NAME}"
  security_groups = ["${aws_security_group.gitlab-runner-fleet.id}"]
  subnet_id = "${random_shuffle.random_subnet.result[0]}"

  provisioner "file" {
    source      = "install-python.sh"
    destination = "/tmp/install-python.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install-python.sh",
      "sudo /tmp/install-python.sh",
    ]
  }

  connection {
    user        = "${var.INSTANCE_USERNAME}"
    private_key = "${file("${var.PATH_TO_KEY}")}"
    host = "${self.public_ip}"
  }

  tags = {
    Name = "${format("gitlab-runner-fleet-%03d", count.index + 1)}"
  }
  # provisioner "local-exec" {
  #   command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u '${var.INSTANCE_USERNAME}' -i '${self.public_ip},' --private-key ${var.PATH_TO_KEY} --extra-vars 'gitlab_runner_name=${format("gitlab-runner-fleet-%03d", count.index + 1)}' ../ansible-play/play.yaml"
  # }
}