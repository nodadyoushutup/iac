resource "spacelift_environment_variable" "pyvenv" { 
    depends_on = [spacelift_context.env_flag]
    context_id  = spacelift_context.env_flag.id
    name        = "TF_VAR_PYVENV" 
    value       = var.PYVENV == 2 ? var.PYVENV : var.PYVENV + 1
    write_only  = false 
    description = "Runner Python virtual environment"
}

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



