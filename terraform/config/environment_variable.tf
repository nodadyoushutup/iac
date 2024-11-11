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
