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

resource "nginxproxymanager_proxy_host" "example" {
  domain_names   = ["example.com"]
  forward_host   = "example2.com"
  forward_port   = 443
  forward_scheme = "https"

  ssl_forced      = false
  hsts_enabled    = false
  hsts_subdomains = false
  http2_support   = false
}
