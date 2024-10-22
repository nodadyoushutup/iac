locals {
  env = try(var.ENV != null && var.ENV != "" && var.ENV > 0 ? var.ENV : 0, 0)
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  private_key = try(var.PRIVATE_KEY != null && var.PRIVATE_KEY != "" ? var.PRIVATE_KEY : "/mnt/workspace/id_rsa")
  ansible_config_path = try(var.ANSIBLE_CONFIG != null && var.ANSIBLE_CONFIG != "" ? var.ANSIBLE_CONFIG : "/mnt/workspace/source/config/ansible.cfg")
  config = try(yamldecode(file(local.config_path)), {
    dependency_deploy = {
      docker = {
        infra = false
        init = false
      }
    }
    path = {
      private_key     = "/mnt/workspace/source/default/id_rsa"
      inventory       = "/mnt/workspace/source/default/inventory"
      env             = "/mnt/workspace/source/default/.env"
      gitconfig       = "/mnt/workspace/source/config/.gitconfig"
      ansible         = "/mnt/workspace/source/config/ansible.cfg"
      prometheus      = "/mnt/workspace/source/config/prometheus.yml"
      docker_compose  = "/mnt/workspace/source/config/docker-compose.yaml"
    }
  })
  base64 = {
    config = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/default/config.yaml"))
    private_key = try(filebase64(local.config.path.private_key), filebase64("/mnt/workspace/source/default/id_rsa"))
    inventory = try(filebase64(local.config.path.inventory), filebase64("/mnt/workspace/source/default/inventory"))
    env = try(filebase64(local.config.path.env), filebase64("/mnt/workspace/source/default/.env"))
    ansible = try(filebase64(local.config.path.ansible), filebase64("/mnt/workspace/source/config/ansible.cfg"))
    docker_compose = try(filebase64(local.config.path.docker_compose), filebase64("/mnt/workspace/source/config/docker-compose.yaml"))
    prometheus = try(filebase64(local.config.path.prometheus), filebase64("/mnt/workspace/source/config/prometheus.yml"))
  }
}