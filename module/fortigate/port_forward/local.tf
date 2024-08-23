# modules/fortigate/port_forward/local.tf

locals {
  provider = try(yamldecode(file("/mnt/workspace/config.yaml")), {})
}