provider "aws" {
  region = var.aws_credentials.region
  access_key = var.aws_credentials.access_key
  secret_key = var.aws_credentials.secret_key
}