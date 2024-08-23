locals {
  config = try(yamldecode(file("/mnt/workspace/config.yaml")), yamldecode(file("/mnt/workspace/config.yml")))
  stack = try(lookup(local.config.stack, var.component, {}), {})
}