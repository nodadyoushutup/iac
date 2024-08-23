locals {
  provider = yamldecode(file("/mnt/workspace/config.yaml"))
  config = try(yamldecode(file("/mnt/workspace/config.yaml")), yamldecode(file("/mnt/workspace/config.yml")))
}
