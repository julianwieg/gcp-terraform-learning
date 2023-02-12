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

module "folders" {
  source  = "terraform-google-modules/folders/google"
  version = "~> 3.0"

  parent  = "folders/608604741391"

  names = [
    "dev",
    "staging",
    "production",
  ]

  set_roles = true

  prefix = "fldr"
  
  per_folder_admins = {
    dev = "group:gcp-organization-admins@wieg.me"
    staging = "group:gcp-organization-admins@wieg.me"
    production = "group:gcp-organization-admins@wieg.me"
  }

  all_folder_admins = [
    "group:gcp-organization-admins@wieg.me",
  ]
}
