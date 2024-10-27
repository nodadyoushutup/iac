locals {
  env = try(var.ENV != null && var.ENV != "" && var.ENV != false && var.ENV > 0 ? var.ENV : 0, 0)
  env_msg = {
    valid = {
      gitconfig = "Gitconfig is valid"
      private_key = "Private key is valid"
    }
    invalid = {
      gitconfig = "Gitconfig is not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
      private_key = "Private key is not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
    }
  }
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    spacelift = {
      dependency_deploy = {
        docker = {
          infra = false
          init = false
        }
        collector = {
          init = false
        }
        grafana = {
          init: false
          config: false
        }
      }
      path = {
        private_key = "/mnt/workspace/source/default/id_rsa"
        ansible = {
          config = "/mnt/workspace/source/config/ansible.cfg"
        }
        docker = {
          compose = "/mnt/workspace/source/config/docker-compose.yaml"
        }
      }
    }
    virtual_machine = {
      username = "ubuntu"
      password = "ubuntu"
      keys = []
    }
  })
  base64 = {
    config = try(filebase64(local.config_path), filebase64("/mnt/workspace/source/default/config.yaml"))
    private_key = try(filebase64(local.config.spacelift.path.private_key), filebase64("/mnt/workspace/source/default/id_rsa"))
    ansible = {
      config = try(filebase64(local.config.spacelift.path.ansible.config), filebase64("/mnt/workspace/source/config/ansible.cfg"))
    }
    docker = {
      compose = try(filebase64(local.config.spacelift.path.docker.compose), filebase64("/mnt/workspace/source/config/docker-compose.yaml"))
    }
  }
}