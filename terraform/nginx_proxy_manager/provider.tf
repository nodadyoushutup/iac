terraform { 
  required_providers { 
    nginxproxymanager = { 
      source = "Sander0542/nginxproxymanager" 
    } 
  } 
} 
 
provider "nginxproxymanager" { 
  host     = local.config.provider.nginx_proxy_manager.host 
  username = local.config.provider.nginx_proxy_manager.username 
  password = local.config.provider.nginx_proxy_manager.password 
} 
