# modules/fortigate/vip/main.tf

resource "fortios_firewall_vip" "vip" {
  arp_reply                        = var.arp_reply
  color                            = var.color
  dns_mapping_ttl                  = var.dns_mapping_ttl
  extintf                          = var.extintf
  extip                            = var.extip
  extport                          = var.extport
  fosid                            = var.fosid
  http_cookie_age                  = var.http_cookie_age
  http_cookie_domain_from_host     = var.http_cookie_domain_from_host
  http_cookie_generation           = var.http_cookie_generation
  http_cookie_share                = var.http_cookie_share
  http_ip_header                   = var.http_ip_header
  http_multiplex                   = var.http_multiplex
  https_cookie_secure              = var.https_cookie_secure
  ldb_method                       = var.ldb_method
  mappedport                       = var.mappedport
  max_embryonic_connections        = var.max_embryonic_connections
  name                             = var.name
  nat_source_vip                   = var.nat_source_vip
  outlook_web_access               = var.outlook_web_access
  persistence                      = var.persistence
  portforward                      = var.portforward
  portmapping_type                 = var.portmapping_type
  protocol                         = var.protocol
  ssl_algorithm                    = var.ssl_algorithm
  ssl_client_fallback              = var.ssl_client_fallback
  ssl_client_renegotiation         = var.ssl_client_renegotiation
  ssl_client_session_state_max     = var.ssl_client_session_state_max
  ssl_client_session_state_timeout = var.ssl_client_session_state_timeout
  ssl_client_session_state_type    = var.ssl_client_session_state_type
  ssl_dh_bits                      = var.ssl_dh_bits
  ssl_hpkp                         = var.ssl_hpkp
  ssl_hpkp_age                     = var.ssl_hpkp_age
  ssl_hpkp_include_subdomains      = var.ssl_hpkp_include_subdomains
  ssl_hsts                         = var.ssl_hsts
  ssl_hsts_age                     = var.ssl_hsts_age
  ssl_hsts_include_subdomains      = var.ssl_hsts_include_subdomains
  ssl_http_location_conversion     = var.ssl_http_location_conversion
  ssl_http_match_host              = var.ssl_http_match_host
  ssl_max_version                  = var.ssl_max_version
  ssl_min_version                  = var.ssl_min_version
  ssl_mode                         = var.ssl_mode
  ssl_pfs                          = var.ssl_pfs
  ssl_send_empty_frags             = var.ssl_send_empty_frags
  ssl_server_algorithm             = var.ssl_server_algorithm
  ssl_server_max_version           = var.ssl_server_max_version
  ssl_server_min_version           = var.ssl_server_min_version
  ssl_server_session_state_max     = var.ssl_server_session_state_max
  ssl_server_session_state_timeout = var.ssl_server_session_state_timeout
  ssl_server_session_state_type    = var.ssl_server_session_state_type
  type                             = var.type
  weblogic_server                  = var.weblogic_server
  websphere_server                 = var.websphere_server
  mappedip {
    range = var.mappedip.range
  }
}
