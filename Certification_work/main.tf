data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
}
resource "aws_key_pair" "jenkins" {
  key_name = "jenkins-key"
  public_key = var.ssh_public_key
  // public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC3FwBwbjXBzA5xNxsKTUZ1fOrYIuEY92DZuxbP1N5CyUQ9f5y/sEf+SmElI2SFPPXnlTfrbhognR+00eky7WsZE2ecqGgE0OSBxbgZ8+1LM4JIsCGkCKrmM4HWQ4vBVRz2alkXDVNhujLDk4klhjQPB5nejcAQ3C+cdFqubXVb/KMile96dUQFkMfxUYtKY5D27iJ0+PEWLiA+iOpJaVaxw1DmV36xyp0TRDz6NpHl+dHrmkfaZTi9MSG0zzXNM6WJeNQB7xU9L9lM3QRxlHdeA9+vZovv787UZQSeS56VMTrzXKwpbW9Wb0ge7AxwW++pFWhcI+K0ub/vIpUtYukdqcgPMWGOSXY9ExNzLlZENqMlCQ0Pzf00v4tA0qP6S240jDRWjBmv3J6XmYIMFfFJWNarFGjmSFG63QNxMcIcS+P249X3DSJUg8tcrdzcKXkt5Wda01x+fjoFF18N4cdQnzKYSnvjDlSwmnWUggU3o9HtiWQly4SUNPQBSv3JS0= root@devs-10-jenkins"
}
resource "aws_instance" "build" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.jenkins.id}"
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  provisioner "local-exec" {
    command = "echo ${aws_instance.build.public_ip} > ec2_build_public_ip" // save instance public ip to file
  }
}
resource "aws_instance" "prod" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.jenkins.id}"
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  provisioner "local-exec" {
    command = "echo ${aws_instance.prod.public_ip} > ec2_prod_public_ip"  // save instance public ip to file
  }
}
