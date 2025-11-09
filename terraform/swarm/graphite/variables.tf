variable "provider_config" {
  description = "Provider configuration map for Docker (host + optional ssh opts)."
  type = object({
    docker = object({
      host     = string
      ssh_opts = optional(list(string))
    })
  })
}
