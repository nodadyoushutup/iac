terraform {
  backend "s3" {
    key = "grafana.tfstate"
  }

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.6.2"
    }

    grafana = {
      source  = "grafana/grafana"
      version = "4.13.0"
    }
  }
}

locals {
  grafana_provider_url = coalesce(
    try(var.provider_config.grafana.url, null),
    "http://localhost:3000"
  )

  grafana_provider_username = coalesce(
    try(var.provider_config.grafana.username, null),
    "admin"
  )

  grafana_provider_password = coalesce(
    try(var.provider_config.grafana.password, null),
    ""
  )

  grafana_provider_auth = coalesce(
    try(var.provider_config.grafana.api_token, null),
    format("%s:%s", local.grafana_provider_username, local.grafana_provider_password)
  )
}

provider "docker" {
  host     = var.provider_config.docker.host
  ssh_opts = var.provider_config.docker.ssh_opts
}

provider "grafana" {
  url  = local.grafana_provider_url
  auth = local.grafana_provider_auth
}
