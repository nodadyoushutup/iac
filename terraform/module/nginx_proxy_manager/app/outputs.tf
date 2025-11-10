output "stack_name" {
  description = "Logical stack namespace for Nginx Proxy Manager resources"
  value       = local.stack_name
}

output "service_name" {
  description = "Docker Swarm service name for the application container"
  value       = docker_service.nginx_proxy_manager.name
}

output "network_name" {
  description = "Overlay network backing the service"
  value       = docker_network.nginx_proxy_manager.name
}

output "data_volume_name" {
  description = "Docker volume that stores application state (SQLite DB, uploads, JWT keys)"
  value       = docker_volume.nginx_proxy_manager_data.name
}

output "letsencrypt_volume_name" {
  description = "Docker volume that stores Let's Encrypt assets"
  value       = docker_volume.nginx_proxy_manager_letsencrypt.name
}

output "admin_email" {
  description = "Bootstrap administrator email injected via INITIAL_ADMIN_EMAIL"
  value       = var.secrets.admin_email
}

output "letsencrypt_email" {
  description = "Primary Let's Encrypt contact email (forwarded to config stage)"
  value       = var.secrets.letsencrypt_email
}

output "image_reference" {
  description = "Container image (tag + digest) deployed for this service"
  value       = local.image
}

output "published_ports" {
  description = "Map of logical ports exposed by the service"
  value       = local.published_ports
}
