terraform { 
  required_providers { 
    nginxproxymanager = { 
      source = "Sander0542/nginxproxymanager" 
    } 
  } 
} 
 
provider "nginxproxymanager" { 
  host     = local.config.spacelift.provider.nginx_proxy_manager.host 
  username = local.config.spacelift.provider.nginx_proxy_manager.email 
  password = local.config.spacelift.provider.nginx_proxy_manager.password 
} 

resource "nginxproxymanager_proxy_host" "nodadyoushutup" {
  domain_names   = ["nodadyoushutup.com"]
  forward_host   = "192.168.1.100"
  forward_port   = 9055
  forward_scheme = "http"

  ssl_forced      = true
  hsts_enabled    = true
  hsts_subdomains = true
  http2_support   = true

}
