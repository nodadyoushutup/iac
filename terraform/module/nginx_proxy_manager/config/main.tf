locals {
  npm_provider = var.provider_config.nginx_proxy_manager

  provider_username = local.npm_provider.username
  provider_password = try(local.npm_provider.password, null)

  certificates = {
    for cert in coalesce(var.config.certificates, []) : cert.name => cert
  }

  proxy_hosts = {
    for host in coalesce(var.config.proxy_hosts, []) : host.name => host
  }

  access_lists = {
    for list in coalesce(var.config.access_lists, []) : list.name => list
  }

  stack_namespace = coalesce(
    try(var.app_state.stack_name, null),
    "nginx-proxy-manager",
  )
}

provider "nginxproxymanager" {
  url      = local.npm_provider.url
  username = local.provider_username
  password = local.provider_password
}

resource "nginxproxymanager_access_list" "this" {
  for_each = local.access_lists

  name        = each.value.name
  pass_auth   = try(each.value.pass_auth, true)
  satisfy_any = try(each.value.satisfy_any, false)

  authorizations = [
    for item in coalesce(each.value.authorizations, []) : {
      username = item.username
      password = item.password
    }
  ]

  access = [
    for rule in coalesce(each.value.access, []) : {
      directive = rule.directive
      address   = rule.address
    }
  ]
}

resource "nginxproxymanager_certificate_letsencrypt" "this" {
  for_each = {
    for name, cert in local.certificates : name => cert
    if try(cert.request_le, true)
  }

  domain_names = toset(each.value.domain_names)
  letsencrypt_email = coalesce(
    try(each.value.email_address, null),
    local.npm_provider.email,
  )
  letsencrypt_agree = true

  dns_challenge            = try(each.value.dns_challenge, false)
  dns_provider             = try(each.value.dns_provider, null)
  dns_provider_credentials = try(each.value.dns_provider_credentials, null)
  propagation_seconds      = try(each.value.propagation_seconds, null)
}

locals {
  certificate_ids = {
    for name, cert in nginxproxymanager_certificate_letsencrypt.this : name => cert.id
  }

  access_list_ids = {
    for name, acl in nginxproxymanager_access_list.this : name => acl.id
  }
}

resource "nginxproxymanager_proxy_host" "this" {
  for_each = local.proxy_hosts

  domain_names   = toset(each.value.domain_names)
  forward_scheme = lower(each.value.scheme)
  forward_host   = each.value.forward_host
  forward_port   = each.value.forward_port

  block_exploits          = try(each.value.block_exploits, true)
  ssl_forced              = try(each.value.ssl_forced, true)
  caching_enabled         = try(each.value.caching_enabled, false)
  allow_websocket_upgrade = try(each.value.allow_websocket_upgrade, true)
  http2_support           = try(each.value.http2_support, true)
  hsts_enabled            = try(each.value.hsts_enabled, false)
  hsts_subdomains         = try(each.value.hsts_subdomains, false)
  advanced_config         = try(each.value.advanced_config, null)

  access_list_id = coalesce(
    try(each.value.access_list_id, null),
    try(local.access_list_ids[try(each.value.access_list, "__missing__")], null),
    null,
  )

  certificate_id = (
    contains(keys(local.certificate_ids), try(each.value.certificate, ""))
    ? local.certificate_ids[each.value.certificate]
    : null
  )

  locations = [
    for location in coalesce(each.value.locations, []) : {
      path            = location.path
      forward_scheme  = lower(location.scheme)
      forward_host    = location.forward_host
      forward_port    = location.forward_port
      advanced_config = try(location.advanced_config, null)
    }
  ]
}
