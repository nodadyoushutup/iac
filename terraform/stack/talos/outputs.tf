# output "talosconfig" {
#   value     = data.talos_client_configuration.this.talos_config
#   sensitive = true
# }

output "kubeconfig" {
  value = data.talos_cluster_kubeconfig.talos
  sensitive = false
}