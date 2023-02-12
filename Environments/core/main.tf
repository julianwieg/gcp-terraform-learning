terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.52.0"
    }
  }
}

provider "google" {
  credentials = var.GOOGLE_CREDENTIALS
}

provider "google-beta" {
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

module "project-factory" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.0"
  random_project_id       = true
  name                    = "shared-logging"
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = "deprivilege"
  /*
  activate_api_identities = [{
    api = "storage.googleapis.com"
  }]
  */
}

module "log_export" {
  source                 = "terraform-google-modules/log-export/google"
  destination_uri        = "${module.destination.destination_uri}"
  filter                 = "severity >= ERROR"
  log_sink_name          = "storage_logsink"
  include_children       = "true"
  parent_resource_id     = "608604741391"
  parent_resource_type   = "folder"
  unique_writer_identity = true
}

module "destination" {
  source                   = "terraform-google-modules/log-export/google//modules/storage"
  project_id               = module.project-factory.project_id
  storage_bucket_name      = "logging_bucket"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
}