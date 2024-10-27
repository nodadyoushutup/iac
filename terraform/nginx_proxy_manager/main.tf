resource "null_resource" "dummy_success" {}

resource "nginxproxymanager_proxy_host" "nodadyoushutup" {
  domain_names     = ["nodadyoushutup.com", "www.nodadyoushutup.com"]
  forward_host     = "192.168.1.100"
  forward_port     = 9055
  forward_scheme   = "http"
  certificate_id   = "2"
  ssl_forced       = 1
  hsts_enabled     = true
  hsts_subdomains  = true
  http2_support    = true
  depends_on       = [null_resource.dummy_success]
}