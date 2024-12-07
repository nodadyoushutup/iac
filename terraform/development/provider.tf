terraform {
  required_providers {
    linux = {
      source = "TelkomIndonesia/linux"
    }
  }
}

provider "linux" {
  host = local.config.data.development.ip_address.external
  port = local.config.data.development.port.external
  user = local.config.data.development.username
  private_key = file(local.config.data.development.private_key)
}

output "development" {
  value = local.config.data.development
}

output "private_key" {
  value = file(local.config.data.development.private_key)
}