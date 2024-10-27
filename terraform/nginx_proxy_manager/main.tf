# # Manage a proxy host
# resource "nginxproxymanager_proxy_host" "grafana" {
#   domain_names = ["grafana.nodadyoushutup.com"]

#   forward_scheme = "http"
#   forward_host   = "192.168.1.101"
#   forward_port   = 80

#   caching_enabled         = true
#   allow_websocket_upgrade = true
#   block_exploits          = true

#   access_list_id = 0 # Publicly Accessible

#   certificate_id  = 0 # No Certificate
#   ssl_forced      = false
#   hsts_enabled    = false
#   hsts_subdomains = false
#   http2_support   = false
# }