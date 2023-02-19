output "folders_map" {
  description = "Folder map"
  value = module.folders.folders_map
}

output "vpc_dev_id" {
  description = "development-vpc network"
  value = module.vpc_dev.network_id
}

output "vpc_de_subnets" {
  description = "development-vpc subnets"
  value = module.vpc_dev.subnets
}