variable "GOOGLE_CREDENTIALS" {
  type = string
  sensitive = true
  description = "Google Cloud service account credentials"
}

variable "production_folder_id" {
  type        = string
  description = "The id of the production folder"
}

variable "development_folder_id" {
  type        = string
  description = "The id of the development folder"
}

variable "project_prefix" {
  type        = string
  description = "Used to prefix the project names to ensure global uniqueness"
}

variable "team_names" {
  type        = list(string)
  description = "The name of the team to be onboarded"
}