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

// setup logging project 
module "project-factory-logging" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.0"
  random_project_id       = true
  name                    = "shared-logging"
  folder_id               = module.folders.folders_map["common"].name
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

// setup our shared vpc and vpc project
module "project-factory-network" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.0"
  random_project_id       = true
  name                    = "shared-network"
  folder_id               = module.folders.folders_map["common"].name
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = "deprivilege"
  
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
  ]
}

module "vpc_dev" {
    source  = "terraform-google-modules/network/google"
    version = "~> 6.0"

    project_id   = module.project-factory-network.project_id
    network_name = "development-vpc"
    routing_mode = "GLOBAL"
    shared_vpc_host = "true"

    delete_default_internet_gateway_routes = "true"

    subnets = [
        {
            subnet_name           = "subnet-public"
            subnet_ip             = "10.0.0.0/24"
            subnet_region         = "us-west1"
            description           = "Subnet for public access"
        },
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.0.0/24"
            subnet_region         = "us-west1"
            description           = "This subnet 10.10.0.0/24 has a description"
        },
        {
            subnet_name           = "subnet-node-01"
            subnet_ip             = "10.20.0.0/24"
            subnet_region         = "us-west1"
            description           = "This subnet 10.20.0.0/24 has a description"
        },
        {
            subnet_name           = "subnet-pods-01"
            subnet_ip             = "192.168.0.0/24"
            subnet_region         = "us-west1"
            description           = "This subnet 192.168.0.0/24 has a description"
        }
    ]

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        }
      ]
}