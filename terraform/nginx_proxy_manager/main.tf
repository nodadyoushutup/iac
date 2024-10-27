# resource "nginxproxymanager_certificate_custom" "example" {
#   name = "example.com"

#   certificate     = file("example.pem")
#   certificate_key = file("example.key")
# }

# resource "nginxproxymanager_proxy_host" "nodadyoushutup" {
#   domain_names   = ["nodadyoushutup.com"]
#   forward_host   = "192.168.1.100"
#   forward_port   = 9055
#   forward_scheme = "http"
#   certificate_id = "2"
#   ssl_forced = true
#   hsts_enabled = false
#   hsts_subdomains = false
#   http2_support = false
# }

# Fetch all certificates
data "nginxproxymanager_certificates" "all" {}

output "nginxproxymanager_certificates" {
  value = data.nginxproxymanager_certificates.all
}