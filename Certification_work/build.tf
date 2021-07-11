resource "tls_private_key" "example" {
  algorithm = "RSA"
}

resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_instance" "build" {
  ami = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.jenkins.id}"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  provisioner "local-exec" {
    command = "sudo echo [build] ${aws_instance.build.public_ip} >> /etc/ansible/hosts"
  }
}

