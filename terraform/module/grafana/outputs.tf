output "service_name" {
  description = "Name of the Grafana Swarm service"
  value       = docker_service.grafana.name
}

output "network_name" {
  description = "Primary overlay network backing Grafana"
  value       = docker_network.grafana.name
}

output "data_volume_name" {
  description = "Docker volume storing Grafana data"
  value       = docker_volume.grafana_data.name
}

output "admin_password_secret_name" {
  description = "Docker secret handing the Grafana admin password"
  value       = docker_secret.grafana_admin_password.name
}
