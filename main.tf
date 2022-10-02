provider "google" {
  project = "terraformproject-364311"
  region  = "europe-north1"
  zone    = "europe-north1-a"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

terraform {
  cloud {
    organization = "wiegme"

    workspaces {
      name = "gcp-wiegme"
    }
  }
}
