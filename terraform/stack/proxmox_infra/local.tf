locals {
  config = yamldecode(try(file(var.PATH_CONFIG), {}))
}

output "debug" {
  value = local.config
}