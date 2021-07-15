provider "aws" {}

data "aws_ami" "latest_ubuntu" {
  owners      = var.aws_ami_owners
  most_recent = true
  filter {
    name   = "name"
    values = var.aws_ami_filter_value
  }
}

resource "aws_security_group" "aws_sg" {
  name        = "allow_ports"
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
  key_name   = "jenkins-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "build" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.ec2_istance_type
  key_name               = aws_key_pair.jenkins.id
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  tags = {
    Name = "build"
  }
}

resource "aws_instance" "stage" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.ec2_istance_type
  key_name               = aws_key_pair.jenkins.id
  vpc_security_group_ids = [aws_security_group.aws_sg.id]
  tags = {
    Name = "stage"
  }
}

data "template_file" "inventory" {
  template = file("inventory.tpl")
  vars = {
    build_address = "${aws_instance.build.public_ip}"
    stage_address = "${aws_instance.stage.public_ip}"
  }
}

resource "local_file" "inventory" {
  filename = "inventory"
  content  = data.template_file.inventory.rendered
}