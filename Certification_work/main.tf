//resource "tls_private_key" "example" {
//  algorithm = "RSA"
//}

resource "aws_key_pair" "jenkins" {
  key_name = "jenkins-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC3FwBwbjXBzA5xNxsKTUZ1fOrYIuEY92DZuxbP1N5CyUQ9f5y/sEf+SmElI2SFPPXnlTfrbhognR+00eky7WsZE2ecqGgE0OSBxbgZ8+1LM4JIsCGkCKrmM4HWQ4vBVRz2alkXDVNhujLDk4klhjQPB5nejcAQ3C+cdFqubXVb/KMile96dUQFkMfxUYtKY5D27iJ0+PEWLiA+iOpJaVaxw1DmV36xyp0TRDz6NpHl+dHrmkfaZTi9MSG0zzXNM6WJeNQB7xU9L9lM3QRxlHdeA9+vZovv787UZQSeS56VMTrzXKwpbW9Wb0ge7AxwW++pFWhcI+K0ub/vIpUtYukdqcgPMWGOSXY9ExNzLlZENqMlCQ0Pzf00v4tA0qP6S240jDRWjBmv3J6XmYIMFfFJWNarFGjmSFG63QNxMcIcS+P249X3DSJUg8tcrdzcKXkt5Wda01x+fjoFF18N4cdQnzKYSnvjDlSwmnWUggU3o9HtiWQly4SUNPQBSv3JS0= root@devs-10-jenkins"
}
resource "aws_instance" "build" {
  ami = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.jenkins.id}"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  provisioner "local-exec" {
    command = "echo ${aws_instance.build.public_ip} > ec2_build_public_ip"
  }
}
resource "aws_instance" "prod" {
  ami = "ami-05f7491af5eef733a"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.jenkins.id}"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  provisioner "local-exec" {
    command = "echo ${aws_instance.prod.public_ip} > ec2_prod_public_ip"
    environment = {
      AWS_ACCESS_KEY_ID = var.aws_credentials.access_key
      AWS_SECRET_ACCESS_KEY = var.aws_credentials.secret_key
    }
  }
}
