resource "grafana_data_source" "prometheus" {
    name = "prometheus"
    type = "prometheus"
    url  = "http://${local.config.provider.prometheus.hostname}"

  # Uncomment and configure the following lines if needed
  # basic_auth_enabled  = true
  # basic_auth_username = "username"

  # json_data_encoded = jsonencode({
  #   httpMethod        = "POST"
  #   prometheusType    = "Mimir"
  #   prometheusVersion = "2.4.0"
  # })

  # secure_json_data_encoded = jsonencode({
  #   basicAuthPassword = "password"
  # })
}

resource "grafana_dashboard" "node_exporter_full" {
    config_json = file("./dashboard/node_exporter_full.json")
}