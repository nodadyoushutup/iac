terraform {
    required_providers {
        grafana = {
            source = "grafana/grafana"
        }
    }
}

provider "grafana" {
    url  = local.config.provider.grafana.url
    auth = local.config.provider.grafana.auth
}
