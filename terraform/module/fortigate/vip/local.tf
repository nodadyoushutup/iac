# modules/fortigate/vip/local.tf

locals {
  provider = try(yamldecode(file("/mnt/workspace/config.yaml")), {})
}