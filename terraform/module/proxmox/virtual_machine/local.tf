locals {
  config_path = try(var.PATH_CONFIG != null && var.PATH_CONFIG != "" ? var.PATH_CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {})
}

