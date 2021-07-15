variable "ec2_istance_type" {
  description = "Type of instance to start"
  default = "t2.micro"
}
variable "aws_ami_owners" {
  description = "The AWS account ID of the image owner"
  default = ["099720109477"]
}

variable "aws_ami_filter_value" {
  description = "Filter value for data 'aws_ami' "
  default = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list(number)
  default     = ["22", "8080"]
}
