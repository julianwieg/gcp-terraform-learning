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
    "development",
    "staging",
    "production",
    "common",
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

module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = ""
  log_sink_name          = "storage_logsink"
  parent_resource_id     = "608604741391"
  parent_resource_type   = "folder"
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = "sample-project"
  storage_bucket_name      = "storage_example_bucket"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
}