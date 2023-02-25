output "folders_map" {
  description = "Folder map"
  value = module.folders.folders_map
}

output "network_id" {
  description = "development-vpc network"
  value = module.vpc_dev.network_id
}

output "subnets" {
  description = "development-vpc subnets"
  value = module.vpc_dev.subnets
}