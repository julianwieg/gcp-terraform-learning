terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3"
    }
  }
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
}

data "google_folder" "production" {
  folder = var.production_folder_name
}



resource "google_project" "production" {
  name       = "${var.team_name}Production"
  project_id = "${var.project_prefix}-${var.team_name}-prod"
  folder_id  = data.google_folder.production.name
}
