// create random string for buckets
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

// setup folder structure in gcp
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

# Search by fields
data "google_folder" "my_logging_folder" {
  folder = "folders/fldr-common"
}

// setup logging project 
module "project-factory-logging" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.0"
  random_project_id       = true
  name                    = "shared-logging"
  folder_id               = data.my_logging_folder.id
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = "deprivilege"
}


// setup log exporting and destination for gcp
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
  project_id               = module.project-factory-logging.project_id
  storage_bucket_name      = "logging_bucket_${random_string.suffix.result}"
  log_sink_writer_identity = "${module.log_export.writer_identity}"
  force_destroy            = true
}