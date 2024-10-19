### CONTEXT ###
resource "spacelift_context" "config_context" {
    depends_on = [data.spacelift_stack.spacelift]
    description = "Infrastructure as Code  Configuration"
    name        = "config"
}

resource "spacelift_context_attachment" "spacelift_config_context_attachment" {
    depends_on = [spacelift_context.config_context]
    context_id = spacelift_context.config_context.id
    stack_id   = data.spacelift_stack.spacelift.id
    priority   = 0
}

resource "spacelift_context" "ansible_hook_context" {
    depends_on = [data.spacelift_stack.spacelift]
    description = "Ansible hook"
    name        = "ansible_hook"
    before_init = [
        ".././before_init.sh"
    ]
}

### MOUNTED FILE ###
resource "spacelift_mounted_file" "config_mounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = "config.yaml"
    content = local.config_base64
    write_only = false
}

resource "spacelift_mounted_file" "private_keymounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = "id_rsa"
    content = local.private_key_base64
    write_only = false
}

### ENVIRONMENT VARIABLES ###
resource "spacelift_environment_variable" "config_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "TF_VAR_CONFIG" 
    value       = local.config_path
    write_only  = false 
    description = "Terraform configuration path"
}

resource "spacelift_environment_variable" "tf_log_environment_variable" { 
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id  = spacelift_context.config_context.id
    name        = "TF_LOG" 
    value       = "debug"
    write_only  = false 
    description = "Terraform log level"
}

resource "random_id" "trigger" {
  byte_length = 8
}

data "external" "private_key_validation" {
  program = ["bash", "${path.module}/private_key_validation.sh", "/mnt/workspace/id_rsa"]

  query = {
    trigger = random_id.trigger.hex 
  }

  depends_on = [random_id.trigger]
}

resource "spacelift_environment_variable" "env_environment_variable" { 
    depends_on = [
        spacelift_context.config_context,
        spacelift_mounted_file.config_mounted_file,
        spacelift_mounted_file.private_keymounted_file,
        spacelift_environment_variable.config_environment_variable,
        spacelift_environment_variable.tf_log_environment_variable
    ]
    context_id  = spacelift_context.config_context.id
    name        = "TF_VAR_ENV" 
    value       = data.external.private_key_validation.result["valid"] == "true" ? local.valid_env + 1 : 0
    write_only  = false 
    description = "Flag for valid environment initialization"
}

output "valid_check" {
  value = data.external.private_key_validation.result["valid"]
}


# ### DOCKER ###
# resource "spacelift_stack" "docker_infra_stack" {
#     depends_on = [spacelift_context.ansible_hook_context]
#     administrative = true
#     autodeploy = true
#     branch = "main"
#     description = "Docker applications"
#     name = "docker_infra"
#     project_root = "terraform/docker"
#     repository = "iac"
#     terraform_version = "1.5.7"
#     labels = ["terraform", "infra", "docker", "administrative", "p1", "p1a"]
# }

# resource "spacelift_stack" "docker_init_stack" {
#     depends_on = [spacelift_stack.docker_infra_stack]
#     administrative = true
#     autodeploy = true
#     branch = "main"
#     description = "Docker initialization"
#     name = "docker_init"
#     project_root = "ansible/playbook"
#     repository = "iac"
#     labels = ["ansible", "init", "docker", "administrative", "p1", "p1b"]
#     ansible {
#         playbook = "docker_init.yaml"
#     }
# }

# resource "spacelift_context_attachment" "docker_infra_config_context_attachment" {
#     depends_on = [spacelift_stack.docker_infra_stack]
#     context_id = data.spacelift_context.config.id
#     stack_id   = spacelift_stack.docker_infra_stack.id
#     priority   = 0
# }

# resource "spacelift_context_attachment" "docker_init_config_context_attachment" {
#     depends_on = [spacelift_stack.docker_init_stack]
#     context_id = data.spacelift_context.config.id
#     stack_id   = spacelift_stack.docker_init_stack.id
#     priority   = 0
# }

# resource "spacelift_context_attachment" "docker_init_ansible_hook_context_attachment" {
#     depends_on = [spacelift_stack.docker_init_stack, spacelift_context.ansible_hook_context]
#     context_id = spacelift_context.ansible_hook_context.id
#     stack_id   = spacelift_stack.docker_init_stack.id
#     priority   = 0
# }

# # resource "spacelift_stack_dependency" "docker_infra_spacelift_stack_dependency" {
# #   count = local.config.dependency_deploy.infra ? 1 : 0
# #   depends_on = [
# #         data.spacelift_stack.spacelift, 
# #         spacelift_stack.docker_infra_stack,
# #         spacelift_environment_variable.config_environment_variable
# #     ]
# #   stack_id = spacelift_stack.docker_infra_stack.id
# #   depends_on_stack_id = data.spacelift_stack.spacelift.id
# # }

# # resource "spacelift_stack_dependency" "docker_init_docker_infra_stack_dependency" {
# #   count = local.config.dependency_deploy.init ? 1 : 0
# #   depends_on = [
# #         spacelift_stack.docker_infra_stack, 
# #         spacelift_stack.docker_init_stack,
# #         spacelift_environment_variable.config_environment_variable
# #     ]
# #   stack_id = spacelift_stack.docker_init_stack.id
# #   depends_on_stack_id = spacelift_stack.docker_infra_stack.id
# # }

# ### PROMETHEUS ###
# resource "spacelift_stack" "prometheus_init_stack" {
#     depends_on = [spacelift_stack.docker_init_stack]
#     administrative = true
#     autodeploy = true
#     branch = "main"
#     description = "prometheus initialization"
#     name = "prometheus_init"
#     project_root = "ansible/playbook"
#     repository = "iac"
#     labels = ["ansible", "init", "prometheus", "administrative", "p1", "p1b"]
#     ansible {
#         playbook = "prometheus_init.yaml"
#     }
# }

# resource "spacelift_context_attachment" "prometheus_init_config_context_attachment" {
#     depends_on = [spacelift_stack.prometheus_init_stack]
#     context_id = data.spacelift_context.config.id
#     stack_id   = spacelift_stack.prometheus_init_stack.id
#     priority   = 0
# }

# resource "spacelift_context_attachment" "prometheus_init_ansible_hook_context_attachment" {
#     depends_on = [spacelift_stack.prometheus_init_stack, spacelift_context.ansible_hook_context]
#     context_id = spacelift_context.ansible_hook_context.id
#     stack_id   = spacelift_stack.prometheus_init_stack.id
#     priority   = 0
# }

# # resource "spacelift_stack_dependency" "prometheus_init_docker_init_stack_dependency" {
# #     count = local.config.dependency_deploy.init ? 1 : 0
# #     depends_on = [
# #         spacelift_stack.docker_init_stack, 
# #         spacelift_stack.prometheus_init_stack,
# #         spacelift_environment_variable.config_environment_variable
# #     ]
# #     stack_id = spacelift_stack.prometheus_init_stack.id
# #     depends_on_stack_id = spacelift_stack.docker_init_stack.id
# # }

# resource "time_static" "example" {}

