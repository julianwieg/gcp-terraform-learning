provider "google" {
  project = "terraformproject-364311"
  region  = "europe-north1"
  zone    = "europe-north1-a"
}



terraform {
  cloud {
    organization = "wiegme"

    workspaces {
      name = "gcp-wiegme"
    }
  }
}
