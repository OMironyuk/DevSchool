terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = "0.60.0"
    }
  }
}

provider "yandex" {
  token                    = "AQAAAAAEsphYAATuwWvGrL6H7U3xtjfKhT2St0I"
 # service_account_key_file = "path_to_service_account_key_file"
  cloud_id                 = "b1gchdap7uflt27e7238"
  folder_id                = "b1g0a0qj4eah8vmbgdpb"
  zone                     = "ru-central1-b"
}
resource "yandex_compute_instance" "build" {
  name        = "devs14-build"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 4
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = "fd83klic6c8gfgi40urb"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.foo.id}"
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

resource "yandex_vpc_network" "foo" {}

resource "yandex_vpc_subnet" "foo" {
  zone       = "ru-central1-b"
  network_id = "${yandex_vpc_network.foo.id}"
}