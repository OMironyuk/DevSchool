resource "aws_instance" "build" {
  ami           = ami-05f7491af5eef733a
  instance_type = "t3.micro"
}