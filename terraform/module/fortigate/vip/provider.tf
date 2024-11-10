# modules/fortigate/vip/provider.tf

terraform {
  required_providers {
    fortios = {
      source  = "fortinetdev/fortios"
    }
  }
}

provider "fortios" {
    hostname = local.config.provider.fortigatehostname
    insecure = local.config.provider.fortigateinsecure
    username = local.config.provider.fortigateusername
    password = local.config.provider.fortigatepassword
    cabundlefile  = "/mnt/workspace/Fortinet_CA_SSL.crt"
}