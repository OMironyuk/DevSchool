output "sg_id" {
  value = aws_security_group.aws_sg.id
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_ubuntu_ami_name" {
  value = data.aws_ami.latest_ubuntu.name
}

output "app_url" {
  value = "The application is available here: http://${aws_instance.stage.public_ip}:8080/sudokusolver/views/sudoku"
}