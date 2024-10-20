locals {
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    path = {
      private_key = "/mnt/workspace/source/default/id_rsa"
      gitconfig = "/mnt/workspace/source/default/.gitconfig"
      prometheus = "/mnt/workspace/prometheus.yaml"
      ansible = "/mnt/workspace/source/config/ansible.cfg"
      docker_compose = "/mnt/workspace/source/config/docker-compose.yaml"
    }
  })
  env = try(var.ENV != null && var.ENV != "" && var.ENV > 0 ? var.ENV : 0, 0)
  base64 = {
    config = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/default/config.yaml"))
    private_key = try(filebase64(local.config.path.private_key), filebase64("/mnt/workspace/source/default/id_rsa"))
    gitconfig = try(filebase64(local.config.path.gitconfig), filebase64("/mnt/workspace/source/default/.gitconfig"))
  }
}