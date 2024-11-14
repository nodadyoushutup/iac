locals {
  config = try(yamldecode(file(var.PATH_CONFIG)), {})
}