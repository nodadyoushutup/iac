locals {
  env = try(var.ENV != null && var.ENV != "" && var.ENV != false && var.ENV > 0 ? var.ENV : 0, 0)
  env_msg = {
    valid = {
      private_key = "Private key is valid"
    }
    invalid = {
      private_key = "Private key is not valid. See documentation: https://github.com/nodadyoushutup/iac/blob/main/docs/README.md"
    }
  }
  config_path = try(var.CONFIG != null && var.CONFIG != "" ? var.CONFIG : "/mnt/workspace/config.yaml")
  config = try(yamldecode(file(local.config_path)), {
    spacelift = {
      private_key = "/mnt/workspace/source/default/id_rsa"
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
    ansible = {
      defaults = {
        host_key_checking = false
        retry_files_enabled = false
        stdout_callback = "yaml"
      }
      privilege_escalation = {
        become = true
        become_method = "sudo"
        become_user = "root"
        become_ask_pass = false
      }
      ssh_connection = {
        timeout = 10
        pipelining = true
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
    private_key = try(filebase64(local.config.spacelift.private_key), filebase64("/mnt/workspace/source/default/id_rsa"))
  }
}