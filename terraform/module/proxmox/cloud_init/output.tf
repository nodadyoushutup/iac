output "cloud_init_user" {
  value = module.cloud_init_user
}

output "cloud_init_network" {
  value = module.cloud_init_network
}

output "cloud_id" {
  value = module.cloud_init_user.proxmox_virtual_environment_file.id
}

output "network_id" {
  value = module.cloud_init_network.proxmox_virtual_environment_file.id
}
