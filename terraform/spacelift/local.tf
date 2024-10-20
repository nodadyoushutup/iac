locals {
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    path = {
      git = "/mnt/workspace/.gitconfig"
      prometheus = "/mnt/workspace/prometheus.yaml"
      private_key = "/mnt/workspace/source/config/default_id_rsa"
      ansible = "/mnt/workspace/source/config/ansible.cfg"
      docker_compose = "/mnt/workspace/source/config/docker-compose.yaml"
    }
  })
  config_base64 = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/config/default_config.yaml"))
  env = try(var.ENV != null && var.ENV != "" && var.ENV > 0 ? var.ENV : 0, 0)
  private_key_base64 = try(filebase64(local.config.path.private_key), filebase64("/mnt/workspace/source/config/default_id_rsa"))
}