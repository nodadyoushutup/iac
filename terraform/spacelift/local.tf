locals {
  env = try(var.ENV != null && var.ENV != "" && var.ENV > 0 ? var.ENV : 0, 0)
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    path = {
      private_key     = "/mnt/workspace/source/default/id_rsa"
      inventory       = "/mnt/workspace/source/default/inventory"
      env             = "/mnt/workspace/source/default/.env"
      gitconfig       = "/mnt/workspace/source/config/.gitconfig"
      ansible         = "/mnt/workspace/source/config/ansible.cfg"
      prometheus      = "/mnt/workspace/source/config/prometheus.yaml"
      docker_compose  = "/mnt/workspace/source/config/docker-compose.yaml"
    }
  })
  base64 = {
    config = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/default/config.yaml"))
    private_key = try(filebase64(local.config.path.private_key), filebase64("/mnt/workspace/source/default/id_rsa"))
    inventory = try(filebase64(local.config.path.inventory), filebase64("/mnt/workspace/source/default/inventory"))
    env = try(filebase64(local.config.path.env), filebase64("/mnt/workspace/source/default/.env"))
  }
}