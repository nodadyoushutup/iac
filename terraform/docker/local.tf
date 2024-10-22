locals {
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {})
  cloud_config = file("/mnt/workspace/cloud_config.yaml")
}

output "cloud_config" {
  value = local.cloud_config
}