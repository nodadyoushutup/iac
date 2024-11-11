# # INIT


# resource "spacelift_context" "pyvenv" {
#     description = "Runner Python virtual environment hooks"
#     name = "pyvenv"
#     space_id = data.spacelift_space.root.id
#     before_init = [
#         "python3 -m venv venv",
#         "source venv/bin/activate",
#         "pip install --upgrade pip && pip install pyyaml paramiko",
#     ]
# }

# resource "spacelift_context" "env_flag" {
#     description = "Environment flags"
#     name = "env_flag"
#     space_id = data.spacelift_space.root.id
# }

# resource "spacelift_environment_variable" "env_flag_pyvenv" { 
#     depends_on = [spacelift_context.pyvenv]
#     context_id  = spacelift_context.pyvenv.id
#     name        = "TF_VAR_ENV_FLAG_PYVENV" 
#     value       = var.ENV_FLAG_PYVENV == 2 ? var.ENV_FLAG_PYVENV : var.ENV_FLAG_PYVENV + 1
#     write_only  = false 
#     description = "Python virtual environment"
# }

# resource "spacelift_context_attachment" "env_flag_config" {
#     depends_on = [
#         spacelift_context.env_flag,
#         spacelift_environment_variable.pyvenv
#     ]
#     context_id = spacelift_context.pyvenv.id
#     stack_id   = data.spacelift_stack.config.id
#     priority   = 0
# }

# # CONTEXT
# resource "spacelift_context" "config" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [ spacelift_context_attachment.env_flag_config ]
#     description = "Configuration"
#     name = "config"
#     space_id = data.spacelift_space.root.id
# }

# # CONTEXT ATTACHMENT
# resource "spacelift_context_attachment" "config_config" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context.config]
#     context_id = spacelift_context.config[count.index].id
#     stack_id   = data.spacelift_stack.config.id
#     priority   = 0
# }

# # ENVIRONMENT VARIABLE
# resource "spacelift_environment_variable" "branch" { 
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id  = spacelift_context.config[count.index].id
#     name        = "TF_VAR_BRANCH" 
#     value       = var.BRANCH
#     write_only  = false 
#     description = "Environment branch"
# }

# resource "spacelift_environment_variable" "repository" { 
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id  = spacelift_context.config[count.index].id
#     name        = "TF_VAR_REPOSITORY" 
#     value       = var.REPOSITORY
#     write_only  = false 
#     description = "Environment repository"
# }

# resource "spacelift_environment_variable" "private_key" { 
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id  = spacelift_context.config[count.index].id
#     name        = "TF_VAR_PRIVATE_KEY" 
#     value       = var.PRIVATE_KEY
#     write_only  = false 
#     description = "Private key"
# }

# resource "spacelift_environment_variable" "config_path" { 
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id  = spacelift_context.config[count.index].id
#     name        = "TF_VAR_CONFIG_PATH" 
#     value       = var.CONFIG_PATH
#     write_only  = false 
#     description = "IaC configuration path"
# }

# # MOUNTED FILE
# resource "spacelift_mounted_file" "config_mounted_file" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id = spacelift_context.config[count.index].id
#     relative_path = "config.yaml"
#     content = local.base64.config
#     write_only = false
# }

# resource "spacelift_mounted_file" "private_keymounted_file" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id = spacelift_context.config[count.index].id
#     relative_path = "id_rsa"
#     content = local.base64.private_key
#     write_only = true
# }

# # # resource "spacelift_stack" "module" {
# # #     count = var.BRANCH != null && var.REPOSITORY != null ? 1 : 0
# # #     depends_on = [
# # #         spacelift_environment_variable.branch,
# # #         spacelift_environment_variable.repository
# # #    ]
# # #     administrative = true
# # #     autodeploy = true
# # #     branch = var.BRANCH
# # #     description = "Modules"
# # #     name = "module"
# # #     project_root = "terraform/module"
# # #     repository = var.REPOSITORY
# # #     terraform_version = "1.5.7"
# # #     labels = ["module"]
# # # }

