variable "aws_credentials" {
  type = object({
    region = string
    access_key = string
    secret_key = string
  })
}

variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list(number)
}
