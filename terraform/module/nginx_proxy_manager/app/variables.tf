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
  })
}

variable "secrets" {
  description = <<-EOT
  Sensitive values consumed by the Nginx Proxy Manager container.
  Only the admin email/password are injected as environment variables (`INITIAL_ADMIN_*`);
  the remaining values are exposed as outputs for downstream automation (config stage, providers, etc).
  EOT
  type = object({
    admin_email       = string
    admin_password    = string
    admin_api_token   = string
    letsencrypt_email = string
    jwt_secret        = string
  })

  validation {
    condition     = alltrue([for value in values(var.secrets) : trimspace(value) != ""])
    error_message = "All entries in secrets must be non-empty strings."
  }
}
