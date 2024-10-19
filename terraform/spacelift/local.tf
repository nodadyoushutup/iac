locals {
  config_path = try(
    var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml"
  )
  config = try(yamldecode(file(local.config_path)), {})
}

output "config" {
  value = local.config_path
  # value = "test"
}