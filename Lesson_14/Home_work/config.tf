terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.60.0"
    }
  }
}

variable "yandex_credentials" {
  type = object({
    token = string
    storage_access_key = string
    storage_secret_key = string
  })
}

provider "yandex" {
  token = var.yandex_credentials.token
  cloud_id = "b1gchdap7uflt27e7238"
  folder_id = "b1g0a0qj4eah8vmbgdpb"
  zone = "ru-central1-b"
  storage_access_key = var.yandex_credentials.storage_access_key
  storage_secret_key = var.yandex_credentials.storage_secret_key
}

resource "yandex_compute_instance" "build" {
  name = "devs-14-build"
  platform_id = "standard-v2"
  zone = "ru-central1-b"
  allow_stopping_for_update = true

  resources {
    cores = 2
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
      type = "ssh"
      user = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host = "${yandex_compute_instance.build.network_interface.0.nat_ip_address}"
    }
  }
  depends_on = [
    yandex_storage_bucket.bucket]
}

// Unmark if need to create network and subnet
//resource "yandex_vpc_network" "default" {
//  name = "default"
//}

//resource "yandex_vpc_subnet" "default-ru-central1-b" {
// zone = "ru-central1-b"
//  name = "default-ru-central1-b"
//  network_id = "${yandex_vpc_network.default.id}"
//  v4_cidr_blocks = []
//  }

resource "yandex_storage_bucket" "bucket" {
  bucket = "bucket-for-artifact"
  acl    = "public-read"
}

resource "null_resource" "copy_artifact" {
  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${yandex_compute_instance.build.network_interface.0.nat_ip_address}:/home/user/boxfuse-sample-java-war-hello/target/*.war ~"
  }
  depends_on = [
    yandex_compute_instance.build
  ]
}

resource "yandex_storage_object" "artifact_object" {
  bucket = "bucket-for-artifact"
  access_key = var.yandex_credentials.storage_access_key
  secret_key = var.yandex_credentials.storage_secret_key
  key = "hello.war"
  source = "~/hello-1.0.war"

  depends_on = [
    null_resource.copy_artifact
  ]
}

resource "yandex_compute_instance" "prod" {
  name        = "devs-14-prod"
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
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"

  }
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y tomcat9",
      "sudo wget https://storage.yandexcloud.net/${yandex_storage_object.artifact_object.bucket}/${yandex_storage_object.artifact_object.key} -P /var/lib/tomcat9/webapps/"
    ]
    connection {
      type     = "ssh"
      user     = "ubuntu"
      private_key = file("~/.ssh/id_rsa")
      host     = "${yandex_compute_instance.prod.network_interface.0.nat_ip_address}"
    }
  }
}
