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
  folder = var.production_folder_id
}

data "google_folder" "shared" {
  folder = var.nonproduction_folder_id
}

data "google_folder" "development" {
  folder = var.development_folder_id
}

resource "google_project" "production" {
  name       = "${var.team_name}Production"
  project_id = "${var.project_prefix}-${var.team_name}-prod"
  folder_id  = data.google_folder.production.id
}

resource "google_project" "development" {
  name       = "${var.team_name}Development"
  project_id = "${var.project_prefix}-${var.team_name}-dev"
  folder_id  = data.google_folder.development.id
}

resource "google_project" "shared" {
  name       = "${var.team_name}Shared"
  project_id = "${var.project_prefix}-${var.team_name}-shared"
  folder_id  = data.google_folder.production.id
}