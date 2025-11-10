terraform {
  backend "s3" {
    key = "nginx-proxy-manager-config.tfstate"
  }

  required_providers {
    nginxproxymanager = {
      source  = "Sander0542/nginxproxymanager"
      version = "1.2.2"
    }
  }
}
