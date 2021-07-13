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

variable "ssh_public_key" {
  description = "Ssh public key"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDC3FwBwbjXBzA5xNxsKTUZ1fOrYIuEY92DZuxbP1N5CyUQ9f5y/sEf+SmElI2SFPPXnlTfrbhognR+00eky7WsZE2ecqGgE0OSBxbgZ8+1LM4JIsCGkCKrmM4HWQ4vBVRz2alkXDVNhujLDk4klhjQPB5nejcAQ3C+cdFqubXVb/KMile96dUQFkMfxUYtKY5D27iJ0+PEWLiA+iOpJaVaxw1DmV36xyp0TRDz6NpHl+dHrmkfaZTi9MSG0zzXNM6WJeNQB7xU9L9lM3QRxlHdeA9+vZovv787UZQSeS56VMTrzXKwpbW9Wb0ge7AxwW++pFWhcI+K0ub/vIpUtYukdqcgPMWGOSXY9ExNzLlZENqMlCQ0Pzf00v4tA0qP6S240jDRWjBmv3J6XmYIMFfFJWNarFGjmSFG63QNxMcIcS+P249X3DSJUg8tcrdzcKXkt5Wda01x+fjoFF18N4cdQnzKYSnvjDlSwmnWUggU3o9HtiWQly4SUNPQBSv3JS0= root@devs-10-jenkins"
}