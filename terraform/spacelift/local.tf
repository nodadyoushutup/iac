locals {
  env = try(var.ENV != null && var.ENV != "" && var.ENV != false && var.ENV > 0 ? var.ENV : 0, 0)
  env_msg = {
    valid = {
      ansible = {
        inventory = "Ansible inventory is valid"
      }
      docker = {
        env = "Docker env is valid"
      }
      gitconfig = "Gitconfig is valid"
      private_key = "Private key is valid"
    }
    invalid = {
      ansible = {
        inventory = "Ansible inventory is not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
      }
      docker = {
        env = "Docker env not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
      }
      gitconfig = "Gitconfig is not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
      private_key = "Private key is not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
    }
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
    }
  })
  base64 = {
    config = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/default/config.yaml"))
    private_key = try(filebase64(local.config.spacelift.path.private_key), filebase64("/mnt/workspace/source/default/id_rsa"))
    ansible = {
      config = try(filebase64(local.config.spacelift.path.ansible.config), filebase64("/mnt/workspace/source/config/ansible.cfg"))
      inventory = try(filebase64(local.config.spacelift.path.ansible.inventory), filebase64("/mnt/workspace/source/default/inventory"))
    }
    docker = {
      env = try(filebase64(local.config.spacelift.path.docker.env), filebase64("/mnt/workspace/source/default/.env"))
      compose = try(filebase64(local.config.spacelift.path.docker.compose), filebase64("/mnt/workspace/source/config/docker-compose.yaml"))
    }
  }
}