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

variable "instance_parameters" {
  type = object({
    name = string
    count = number
    cores = number
    memory = number
  })
//  default =    {
//    name = "devs-15-1"
//    count = 2
//    cores = 2
//    memory = 2
//  }
}
provider "yandex" {
  token                    = var.yandex_credentials.token
  cloud_id                 = "b1gchdap7uflt27e7238"
  folder_id                = "b1g0a0qj4eah8vmbgdpb"
  zone                     = "ru-central1-b"
  storage_access_key       = var.yandex_credentials.storage_access_key
  storage_secret_key       = var.yandex_credentials.storage_secret_key
}

resource "yandex_compute_instance" "build" {
  count = var.instance_parameters.count
  name = "${var.instance_parameters.name}-${count.index+1}"
  platform_id = "standard-v2"
  zone = "ru-central1-b"

  resources {
    cores = var.instance_parameters.cores
    memory = var.instance_parameters.memory
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
}