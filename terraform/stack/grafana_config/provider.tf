terraform {
    required_providers {
        grafana = {
            source = "grafana/grafana"
        }
    }
}

provider "grafana" {
    url  = local.config.spacelift.provider.grafana.url
    auth = local.config.spacelift.provider.grafana.auth
}
