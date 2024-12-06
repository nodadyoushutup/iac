locals {
  config = yamldecode(try(file(var.CONFIG_PATH), {}))
}

output "debug" {
  value = local.config
}