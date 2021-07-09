variable "aws_credentials" {
  type = object({
    access_key = string
    secret_key = string
  })
}

provider "aws" {
  region = "eu-central-1"
  access_key = var.aws_credentials.access_key
  secret_key = var.aws_credentials.secret_key
}