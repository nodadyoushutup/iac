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

# Manage a proxy host
resource "nginxproxymanager_proxy_host" "example" {
  domain_names = ["example.com"]

  forward_scheme = "https"
  forward_host   = "example2.com"
  forward_port   = 443

  caching_enabled         = true
  allow_websocket_upgrade = true
  block_exploits          = true

  access_list_id = 0 # Publicly Accessible

  location {
    path           = "/admin"
    forward_scheme = "https"
    forward_host   = "example3.com"
    forward_port   = 443

    advanced_config = ""
  }

  location {
    path           = "/contact"
    forward_scheme = "http"
    forward_host   = "example4.com"
    forward_port   = 80

    advanced_config = ""
  }

  certificate_id  = 0 # No Certificate
  ssl_forced      = 0
  hsts_enabled    = 0
  hsts_subdomains = 0
  http2_support   = 0

  advanced_config = ""
}