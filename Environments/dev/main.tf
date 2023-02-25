// create random string for buckets
resource "random_string" "suffix" {
  length  = 4
  upper   = false
  special = false
}

data "terraform_remote_state" "gcp-core" {
  backend = "remote"

  config = {
    organization = "wiegme"
    workspaces = {
      name = "gcp-core_Folders-shared_projects-org_policies-shared_network"
    }
  }
}

// setup dev1-compute project 
module "dev1-compute" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.0"
  random_project_id       = true
  name                    = "proj-dev1-compute"
  folder_id               = data.terraform_remote_state.gcp-core.outputs.folders_map["development"].name
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = "deprivilege"
}

// setup dev2-gke project 
module "dev2-gke" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.0"
  random_project_id       = true
  name                    = "proj-dev2-gke"
  folder_id               = data.terraform_remote_state.gcp-core.outputs.folders_map["development"].name
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = "deprivilege"
}

