locals {
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {})
  ip_address = regex("^([0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)", local.config.virtual_machine.docker.address)
}
