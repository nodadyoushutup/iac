terraform {
  required_providers {
    proxmox = {
      source = "grafana/grafana"
    }
  }
}

provider "grafana" {
  url  = local.config.provider.grafana.url
  auth = local.config.provider.grafana.auth
}

resource "grafana_data_source" "prometheus" {
    name = "prometheus"
    type = "prometheus"
    url = "http://192.168.1.101:9090"
#   basic_auth_enabled  = true
#   basic_auth_username = "username"

#   json_data_encoded = jsonencode({
#     httpMethod        = "POST"
#     prometheusType    = "Mimir"
#     prometheusVersion = "2.4.0"
#   })

#   secure_json_data_encoded = jsonencode({
#     basicAuthPassword = "password"
#   })
}