data "talos_cluster_kubeconfig" "talos" {
  depends_on = [talos_machine_bootstrap.talos]
  client_configuration = talos_machine_secrets.talos.client_configuration
  node = "192.168.1.200"
}