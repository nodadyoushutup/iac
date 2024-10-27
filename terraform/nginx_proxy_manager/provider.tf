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

