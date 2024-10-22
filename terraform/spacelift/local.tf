locals {
  env = try(var.ENV != null && var.ENV != "" && var.ENV != false && var.ENV > 0 ? var.ENV : 0, 0)
  env_msg = {
    valid = "Environment configuration is valid"
    invalid = "Environment configuration is not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
  }
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    dependency_deploy = {
      docker = {
        infra = false
        init = false
      }
    }
    path = {
      private_key = "/mnt/workspace/source/default/id_rsa"
      ansible = {
        config = "/mnt/workspace/source/config/ansible.cfg"
        inventory = "/mnt/workspace/source/default/inventory"
      }
      docker = {
        compose = "/mnt/workspace/source/config/docker-compose.yaml"
        env = "/mnt/workspace/source/default/.env"
      }
      gitconfig = "/mnt/workspace/source/config/.gitconfig"
      prometheus = "/mnt/workspace/source/config/prometheus.yml"
    }
  })
  base64 = {
    config = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/default/config.yaml"))
    private_key = try(filebase64(local.config.path.private_key), filebase64("/mnt/workspace/source/default/id_rsa"))
    ansible = {
      config = try(filebase64(local.config.path.ansible.config), filebase64("/mnt/workspace/source/config/ansible.cfg"))
      inventory = try(filebase64(local.config.path.ansible.inventory), filebase64("/mnt/workspace/source/default/inventory"))
    }
    docker = {
      env = try(filebase64(local.config.path.docker.env), filebase64("/mnt/workspace/source/default/.env"))
      compose = try(filebase64(local.config.path.docker.compose), filebase64("/mnt/workspace/source/config/docker-compose.yaml"))
    }
    prometheus = try(filebase64(local.config.path.prometheus), filebase64("/mnt/workspace/source/config/prometheus.yml"))
  }
}