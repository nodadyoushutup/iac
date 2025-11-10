output "stack_namespace" {
  description = "Namespace observed from the app stage"
  value       = module.nginx_proxy_manager_config.stack_namespace
}

output "certificate_ids" {
  description = "Map of configured certificate names to NPM IDs"
  value       = module.nginx_proxy_manager_config.certificate_ids
}

output "proxy_host_ids" {
  description = "Map of configured proxy host names to NPM IDs"
  value       = module.nginx_proxy_manager_config.proxy_host_ids
}
