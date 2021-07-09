resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBk0ZWh6qSAHvyPnYNFN49xE3ueXEnLVrIzGZGocQy2/A3G8XxT+cXazlrn7pPKiaSH0IhlmZYw8ZgxjSTgvLTvQmFME3KFKou+kfGsT8aD4zRvs1DpDOkvqZFisr9Wj+dUZquCZJjZxJc496rRNfhjvDXpF5tf0UE7FUF2fMq3gLsSzxmWmfkhMq54AMO5uEJiLAR2TmV8lo3bhUYvXjTCbipAehuCz2PuXihhq5qx+TxKlO8qHaEHDqCPxrugQ0nEXFNB4dussh+dm16KuCTpjp+H9d4Oj0MT7n5Tdz0ViWJP9ogOD6WVHLaTFolfegrSdIxI63hOuqVMtoJfhgh root@devs8-m"
}

resource "aws_instance" "build" {
  ami = "ami-05f7491af5eef733a"
  instance_type = "t3.micro"
  key_name = "${aws_key_pair.jenkins.id}"
}