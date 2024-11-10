# modules/fortigate/vip/variable.tf

variable "arp_reply" {
  type    = string
  default = "enable"
}

variable "color" {
  type    = number
  default = 0
}

variable "dns_mapping_ttl" {
  type    = number
  default = 0
}

variable "extintf" {
  type    = string
  default = "wan"
}

variable "extip" {
  type    = string
  default = "0.0.0.0"
}

variable "extport" {
  type    = string
}

variable "fosid" {
  type    = number
}

variable "http_cookie_age" {
  type    = number
  default = 60
}

variable "http_cookie_domain_from_host" {
  type    = string
  default = "disable"
}

variable "http_cookie_generation" {
  type    = number
  default = 0
}

variable "http_cookie_share" {
  type    = string
  default = "same-ip"
}

variable "http_ip_header" {
  type    = string
  default = "disable"
}

variable "http_multiplex" {
  type    = string
  default = "disable"
}

variable "https_cookie_secure" {
  type    = string
  default = "disable"
}

variable "ldb_method" {
  type    = string
  default = "static"
}

variable "mappedport" {
  type    = string
}

variable "max_embryonic_connections" {
  type    = number
  default = 1000
}

variable "name" {
  type    = string
}

variable "nat_source_vip" {
  type    = string
  default = "disable"
}

variable "outlook_web_access" {
  type    = string
  default = "disable"
}

variable "persistence" {
  type    = string
  default = "none"
}

variable "portforward" {
  type    = string
  default = "enable"
}

variable "portmapping_type" {
  type    = string
  default = "1-to-1"
}

variable "protocol" {
  type    = string
  default = "tcp"
}

variable "ssl_algorithm" {
  type    = string
  default = "high"
}

variable "ssl_client_fallback" {
  type    = string
  default = "enable"
}

variable "ssl_client_renegotiation" {
  type    = string
  default = "secure"
}

variable "ssl_client_session_state_max" {
  type    = number
  default = 1000
}

variable "ssl_client_session_state_timeout" {
  type    = number
  default = 30
}

variable "ssl_client_session_state_type" {
  type    = string
  default = "both"
}

variable "ssl_dh_bits" {
  type    = string
  default = "2048"
}

variable "ssl_hpkp" {
  type    = string
  default = "disable"
}

variable "ssl_hpkp_age" {
  type    = number
  default = 5184000
}

variable "ssl_hpkp_include_subdomains" {
  type    = string
  default = "disable"
}

variable "ssl_hsts" {
  type    = string
  default = "disable"
}

variable "ssl_hsts_age" {
  type    = number
  default = 5184000
}

variable "ssl_hsts_include_subdomains" {
  type    = string
  default = "disable"
}

variable "ssl_http_location_conversion" {
  type    = string
  default = "disable"
}

variable "ssl_http_match_host" {
  type    = string
  default = "enable"
}

variable "ssl_max_version" {
  type    = string
  default = "tls-1.3"
}

variable "ssl_min_version" {
  type    = string
  default = "tls-1.1"
}

variable "ssl_mode" {
  type    = string
  default = "half"
}

variable "ssl_pfs" {
  type    = string
  default = "require"
}

variable "ssl_send_empty_frags" {
  type    = string
  default = "enable"
}

variable "ssl_server_algorithm" {
  type    = string
  default = "client"
}

variable "ssl_server_max_version" {
  type    = string
  default = "client"
}

variable "ssl_server_min_version" {
  type    = string
  default = "client"
}

variable "ssl_server_session_state_max" {
  type    = number
  default = 100
}

variable "ssl_server_session_state_timeout" {
  type    = number
  default = 60
}

variable "ssl_server_session_state_type" {
  type    = string
  default = "both"
}

variable "type" {
  type    = string
  default = "static-nat"
}

variable "weblogic_server" {
  type    = string
  default = "disable"
}

variable "websphere_server" {
  type    = string
  default = "disable"
}

variable "mappedip" {
  type    = object({
    range = string
  })
}
