locals {
  config_path = try(
    var.CONFIG != null && var.CONFIG != "" ? var.CONFIG: try(
      fileexists("/mnt/workspace/config.yaml") ? "/mnt/workspace/config.yaml" : null,
      fileexists("/mnt/workspace/config.yml") ? "/mnt/workspace/config.yml" : null,
      fileexists("/mnt/workspace/source/config/config.yaml") ? "/mnt/workspace/source/config/config.yaml" : null,
      fileexists("/mnt/workspace/source/config/config.yml") ? "/mnt/workspace/source/config/config.yml" : null,
      "/mnt/workspace/config.yaml"
    )
  )
  config = try(yamldecode(file(local.config_path)), {})
}

output "config" {
  value = local.config_path
  # value = "test"
}