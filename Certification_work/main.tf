provider "aws" {}

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }
}
resource "aws_security_group" "aws_sg" {
  name = "allow_ports"
  description = "Allow inbound traffic"

  dynamic "ingress" {
    for_each = var.allow_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_key_pair" "jenkins" {
  key_name = "jenkins-key"
  public_key = file("~/.ssh/id_rsa.pub") //var.ssh_public_key
}
resource "aws_instance" "build" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.jenkins.id
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  tags = {
    Name = "build"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.build.public_ip} > ec2_build_public_ip" // save instance public ip to file
  }
}
resource "aws_instance" "prod" {
  ami = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  key_name = aws_key_pair.jenkins.id
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  tags = {
    Name = "prod"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.prod.public_ip} > ec2_prod_public_ip"  // save instance public ip to file
  }
}
