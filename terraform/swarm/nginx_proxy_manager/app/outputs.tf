output "stack_name" {
  description = "Logical stack namespace for Nginx Proxy Manager"
  value       = module.nginx_proxy_manager_app.stack_name
}

output "service_name" {
  description = "Deployed Swarm service name"
  value       = module.nginx_proxy_manager_app.service_name
}

output "network_name" {
  description = "Primary overlay network"
  value       = module.nginx_proxy_manager_app.network_name
}

output "data_volume_name" {
  description = "Volume storing application data"
  value       = module.nginx_proxy_manager_app.data_volume_name
}

output "letsencrypt_volume_name" {
  description = "Volume storing ACME assets"
  value       = module.nginx_proxy_manager_app.letsencrypt_volume_name
}

output "image_reference" {
  description = "Image digest deployed"
  value       = module.nginx_proxy_manager_app.image_reference
}

output "published_ports" {
  description = "Map of published TCP ports"
  value       = module.nginx_proxy_manager_app.published_ports
}
