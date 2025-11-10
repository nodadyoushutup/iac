variable "provider_config" {
  description = "Docker provider inputs (host connection + optional overrides)"
  type = object({
    docker = object({
      host     = string
      ssh_opts = list(string)
    })
    timezone = optional(string)
    puid     = optional(string)
    pgid     = optional(string)
  })
}

variable "secrets" {
  description = "Per-environment secrets for bootstrapping Nginx Proxy Manager"
  type = object({
    admin_email       = string
    admin_password    = string
    admin_api_token   = string
    letsencrypt_email = string
    jwt_secret        = string
  })
}
