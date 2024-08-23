locals {
  config = yamldecode(file("/mnt/workspace/config.yaml"))
}
