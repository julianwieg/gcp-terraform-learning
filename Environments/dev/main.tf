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

// setup dev project 
module "dev_project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 14.0"
  random_project_id       = true
  name                    = "dev-project"
  folder_id               = data.terraform_remote_state.gcp-core.outputs.folders_map["common"].name
  org_id                  = var.organization_id
  billing_account         = var.billing_account
  default_service_account = "deprivilege"
}

