locals {
  env = try(var.ENV != null && var.ENV > 0 ? var.ENV : 0, 0)
  env_msg = {
    valid = "Configuration is valid"
    invalid = "Configuration is not valid"
  }
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    spacelift = {
      private_key = "/mnt/workspace/source/config/default/id_rsa"
      dependency_deploy = {
        docker = {
          infra = false
          init = false
        }
        collector = {
          init = false
        }
        grafana = {
          init = false
          config = false
        }
        nginx_proxy_manager = {
          init = false
          config = false
        }
      }
    }
  })
  base64 = {
    config = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/config/default/config.yaml"))
    private_key = try(filebase64(local.config.spacelift.private_key), filebase64("/mnt/workspace/source/config/default/id_rsa"))
  }
}