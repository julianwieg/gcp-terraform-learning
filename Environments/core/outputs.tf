output "folders_map" {
  description = "Folder map"
  value = module.folders.folders_map
}

output "development-vpc-id" {
  description = "development-vpc network"
  value = module.development-vpc.network_id
}

output "development-vpc-subnets" {
  description = "development-vpc subnets"
  value = module.development-vpc.subnets
}