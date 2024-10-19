output "config" {
  value = var.config
}

locals {
  config = try(
    var.config,
    fileexists("/mnt/workspace/config.yaml") ? "/mnt/workspace/config.yaml" : null,
    fileexists("/mnt/workspace/config.yml") ? "/mnt/workspace/config.yml" : null,
    fileexists("/mnt/workspace/source/config/config.yaml") ? "/mnt/workspace/source/config/config.yaml" : null,
    fileexists("/mnt/workspace/source/config/config.yml") ? "/mnt/workspace/source/config/config.yml" : null
  )
}