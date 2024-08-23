# modules/fortigate/policy/provider.tf

terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
    }
  }
}

provider "fortios" {
    hostname = local.provider.fortigate.hostname
    insecure = local.provider.fortigate.insecure
    username = local.provider.fortigate.username
    password = local.provider.fortigate.password
    cabundlefile  = "/mnt/workspace/Fortinet_CA_SSL.crt"
}