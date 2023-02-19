variable "GOOGLE_CREDENTIALS" {
  type = string
  sensitive = true
  description = "Google Cloud service account credentials"
}

variable "organization_id" {
  type = string
  description = "the google org id"
}

variable "billing_account" {
  type = string
  description = "billing account id"
}