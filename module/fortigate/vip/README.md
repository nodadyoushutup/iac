
# FortiGate VIP Module

This Terraform module allows you to create and manage a Virtual IP (VIP) in a FortiGate device using the FortiOS provider.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "vip" {
  source = "./modules/fortigate/vip"

  arp_reply                        = "enable"
  color                            = 0
  dns_mapping_ttl                  = 0
  extintf                          = "wan"
  extip                            = "0.0.0.0"
  extport                          = "80"
  fosid                            = 1
  http_cookie_age                  = 60
  http_cookie_domain_from_host     = "disable"
  http_cookie_generation           = 0
  http_cookie_share                = "same-ip"
  http_ip_header                   = "disable"
  http_multiplex                   = "disable"
  https_cookie_secure              = "disable"
  ldb_method                       = "static"
  mappedport                       = "8080"
  max_embryonic_connections        = 1000
  name                             = "my-vip"
  nat_source_vip                   = "disable"
  outlook_web_access               = "disable"
  persistence                      = "none"
  portforward                      = "enable"
  portmapping_type                 = "1-to-1"
  protocol                         = "tcp"
  ssl_algorithm                    = "high"
  ssl_client_fallback              = "enable"
  ssl_client_renegotiation         = "secure"
  ssl_client_session_state_max     = 1000
  ssl_client_session_state_timeout = 30
  ssl_client_session_state_type    = "both"
  ssl_dh_bits                      = "2048"
  ssl_hpkp                         = "disable"
  ssl_hpkp_age                     = 5184000
  ssl_hpkp_include_subdomains      = "disable"
  ssl_hsts                         = "disable"
  ssl_hsts_age                     = 5184000
  ssl_hsts_include_subdomains      = "disable"
  ssl_http_location_conversion     = "disable"
  ssl_http_match_host              = "enable"
  ssl_max_version                  = "tls-1.3"
  ssl_min_version                  = "tls-1.1"
  ssl_mode                         = "half"
  ssl_pfs                          = "require"
  ssl_send_empty_frags             = "enable"
  ssl_server_algorithm             = "client"
  ssl_server_max_version           = "client"
  ssl_server_min_version           = "client"
  ssl_server_session_state_max     = 100
  ssl_server_session_state_timeout = 60
  ssl_server_session_state_type    = "both"
  type                             = "static-nat"
  weblogic_server                  = "disable"
  websphere_server                 = "disable"
  mappedip = {
    range = "192.168.1.100-192.168.1.200"
  }
}
```

## Inputs

| Name                             | Description                                                      | Type   | Default    | Required |
|----------------------------------|------------------------------------------------------------------|--------|------------|----------|
| `arp_reply`                      | Enable or disable ARP reply.                                     | `string`| `"enable"` | No       |
| `color`                          | Color for the VIP entry.                                         | `number`| `0`        | No       |
| `dns_mapping_ttl`                | TTL for DNS mapping.                                             | `number`| `0`        | No       |
| `extintf`                        | External interface for the VIP.                                  | `string`| `"wan"`    | No       |
| `extip`                          | External IP for the VIP.                                         | `string`| `"0.0.0.0"`| No       |
| `extport`                        | External port for the VIP.                                       | `string`| N/A        | Yes      |
| `fosid`                          | ID for the VIP entry.                                            | `number`| N/A        | Yes      |
| `http_cookie_age`                | Age for HTTP cookies.                                            | `number`| `60`       | No       |
| `http_cookie_domain_from_host`   | Use HTTP cookie domain from host.                                | `string`| `"disable"`| No       |
| `http_cookie_generation`         | HTTP cookie generation.                                          | `number`| `0`        | No       |
| `http_cookie_share`              | HTTP cookie sharing method.                                      | `string`| `"same-ip"`| No       |
| `http_ip_header`                 | Enable or disable HTTP IP header.                                | `string`| `"disable"`| No       |
| `http_multiplex`                 | Enable or disable HTTP multiplexing.                             | `string`| `"disable"`| No       |
| `https_cookie_secure`            | Enable or disable HTTPS cookie secure option.                    | `string`| `"disable"`| No       |
| `ldb_method`                     | Load balancing method for the VIP.                               | `string`| `"static"` | No       |
| `mappedport`                     | Mapped port for the VIP.                                         | `string`| N/A        | Yes      |
| `max_embryonic_connections`      | Maximum embryonic connections.                                   | `number`| `1000`     | No       |
| `name`                           | Name of the VIP.                                                 | `string`| N/A        | Yes      |
| `nat_source_vip`                 | Enable or disable NAT source VIP.                                | `string`| `"disable"`| No       |
| `outlook_web_access`             | Enable or disable Outlook Web Access.                            | `string`| `"disable"`| No       |
| `persistence`                    | Persistence method for the VIP.                                  | `string`| `"none"`   | No       |
| `portforward`                    | Enable or disable port forwarding.                               | `string`| `"enable"` | No       |
| `portmapping_type`               | Port mapping type for the VIP.                                   | `string`| `"1-to-1"` | No       |
| `protocol`                       | Protocol for the VIP.                                            | `string`| `"tcp"`    | No       |
| `ssl_algorithm`                  | SSL algorithm for the VIP.                                       | `string`| `"high"`   | No       |
| `ssl_client_fallback`            | Enable or disable SSL client fallback.                           | `string`| `"enable"` | No       |
| `ssl_client_renegotiation`       | SSL client renegotiation settings.                               | `string`| `"secure"` | No       |
| `ssl_client_session_state_max`   | Maximum SSL client session state entries.                        | `number`| `1000`     | No       |
| `ssl_client_session_state_timeout`| Timeout for SSL client session state.                           | `number`| `30`       | No       |
| `ssl_client_session_state_type`  | Type of SSL client session state.                                | `string`| `"both"`   | No       |
| `ssl_dh_bits`                    | SSL DH bits.                                                     | `string`| `"2048"`   | No       |
| `ssl_hpkp`                       | Enable or disable SSL HPKP.                                      | `string`| `"disable"`| No       |
| `ssl_hpkp_age`                   | SSL HPKP age.                                                    | `number`| `5184000`  | No       |
| `ssl_hpkp_include_subdomains`    | Enable or disable SSL HPKP for subdomains.                       | `string`| `"disable"`| No       |
| `ssl_hsts`                       | Enable or disable SSL HSTS.                                      | `string`| `"disable"`| No       |
| `ssl_hsts_age`                   | SSL HSTS age.                                                    | `number`| `5184000`  | No       |
| `ssl_hsts_include_subdomains`    | Enable or disable SSL HSTS for subdomains.                       | `string`| `"disable"`| No       |
| `ssl_http_location_conversion`   | Enable or disable SSL HTTP location conversion.                  | `string`| `"disable"`| No       |
| `ssl_http_match_host`            | Enable or disable SSL HTTP host matching.                        | `string`| `"enable"` | No       |
| `ssl_max_version`                | Maximum SSL version.                                             | `string`| `"tls-1.3"`| No       |
| `ssl_min_version`                | Minimum SSL version.                                             | `string`| `"tls-1.1"`| No       |
| `ssl_mode`                       | SSL mode.                                                        | `string`| `"half"`   | No       |
| `ssl_pfs`                        | Enable or disable SSL PFS.                                       | `string`| `"require"`| No       |
| `ssl_send_empty_frags`           | Enable or disable sending empty SSL fragments.                   | `string`| `"enable"` | No       |
| `ssl_server_algorithm`           | SSL server algorithm.                                            | `string`| `"client"` | No       |
| `ssl_server_max_version`         | Maximum SSL server version.                                      | `string`| `"client"` | No       |
| `ssl_server_min_version`         | Minimum SSL server version.                                      | `string`| `"client"` | No       |
