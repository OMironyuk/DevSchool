terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.60.0"
    }
  }
}

variable "token" {
  type    = string
}
variable "storage_access_key" {
  type    = string
}
variable "storage_secret_key" {
  type    = string
}

provider "yandex" {
  token                    = var.token
 # service_account_key_file = "path_to_service_account_key_file"
  cloud_id                 = "b1gchdap7uflt27e7238"
  folder_id                = "b1g0a0qj4eah8vmbgdpb"
  zone                     = "ru-central1-b"
  storage_access_key       = var.storage_access_key
  storage_secret_key       = var.storage_secret_key
}
resource "yandex_compute_instance" "build" {
  name        = "devs14-build"
  platform_id = "standard-v2"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
    core_fraction = 20
  }

  scheduling_policy {
    preemptible = true
  }

  boot_disk {
    initialize_params {
      image_id = "fd83klic6c8gfgi40urb"
      size = 10
    }
  }

  network_interface {
    subnet_id = "e2la11hhlvdpko78kgor"
    // subnet_id = "${yandex_vpc_subnet.default-ru-central1-b.id}" - unmark if network and subnet are created
    nat = true
  }

  metadata = {
    foo = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"

  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y git maven",
      "sudo mkdir -p /home/user/ && cd /home/user/ && sudo git clone https://github.com/boxfuse/boxfuse-sample-java-war-hello.git",
      "cd /home/user/boxfuse-sample-java-war-hello && sudo mvn package"
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host     = "${yandex_compute_instance.build.network_interface.0.nat_ip_address}"
    }
  }
}
// Unmark if need to create network and subnet
//resource "yandex_vpc_network" "default" {
//  name = "default"
//}
//
//resource "yandex_vpc_subnet" "default-ru-central1-b" {
// zone = "ru-central1-b"
//  name = "default-ru-central1-b"
//  network_id = "${yandex_vpc_network.default.id}"
//  v4_cidr_blocks = []
//  }
resource "yandex_storage_bucket" "bucket" {
  bucket = "bucket-for-artifact"
  acl = "private"
}
resource "yandex_storage_object" "cute-cat-picture" {
  bucket = "bucket-for-artifact"
  key    = "profile"
  //source =  "terraform.tfstate"
  //source = "ubuntu@${yandex_compute_instance.build.network_interface.0.nat_ip_address}:/home/user/boxfuse-sample-java-war-hello/target/hello-1.0.war"
  source = "ubuntu@${yandex_compute_instance.build.network_interface.0.nat_ip_address}:/home/ubuntu/.ssh/.profile"
}
