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
    nginx_proxy_manager = optional(object({
      username = string
      password = string
      url      = optional(string)
    }))
  })
}
