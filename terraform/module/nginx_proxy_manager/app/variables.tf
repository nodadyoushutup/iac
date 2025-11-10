variable "provider_config" {
  description = "Provider + runtime configuration for Docker and optional overrides"
  type = object({
    docker = object({
      host     = string
      ssh_opts = list(string)
    })
    timezone = optional(string)
    puid     = optional(string)
    pgid     = optional(string)
    nginx_proxy_manager = optional(object({
      username = string
      password = string
      url       = optional(string)
    }))
  })
}
