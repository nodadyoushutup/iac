# CONTEXT
resource "spacelift_context" "config" {
    description = "Configuration"
    name = "config"
    space_id = "root"
}

#CONTEXT ATTACHMENT
resource "spacelift_context_attachment" "config_config" {
    depends_on = [spacelift_context.config]
    context_id = spacelift_context.config.id
    stack_id   = data.spacelift_stack.config.id
    priority   = 0
}

# ENVIRONMENT VARIABLE
resource "spacelift_environment_variable" "env_branch" { 
    depends_on = [spacelift_context_attachment.config_config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_ENV_BRANCH" 
    value       = var.ENV_BRANCH
    write_only  = false 
    description = "Environment branch"
}

resource "spacelift_environment_variable" "env_repository" { 
    depends_on = [spacelift_context_attachment.config_config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_ENV_REPOSITORY" 
    value       = var.ENV_REPOSITORY
    write_only  = false 
    description = "Environment repository"
}

resource "spacelift_environment_variable" "private_key" { 
    depends_on = [spacelift_context_attachment.config_config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_PRIVATE_KEY" 
    value       = var.PRIVATE_KEY
    write_only  = false 
    description = "Private key"
}

resource "spacelift_environment_variable" "config_path" { 
    depends_on = [spacelift_context_attachment.config_config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_CONFIG_PATH" 
    value       = var.CONFIG_PATH
    write_only  = false 
    description = "IaC configuration path"
}

# MOUNTED FILE
resource "spacelift_mounted_file" "config_mounted_file" {
    depends_on = [spacelift_context_attachment.config_config]
    context_id = spacelift_context.config.id
    relative_path = "config.yaml"
    content = local.base64.config
    write_only = false
}

resource "spacelift_mounted_file" "private_keymounted_file" {
    depends_on = [spacelift_context_attachment.config_config]
    context_id = spacelift_context.config.id
    relative_path = "id_rsa"
    content = local.base64.private_key
    write_only = true
}

# resource "spacelift_stack" "module" {
#     count = var.ENV_BRANCH != null && var.ENV_REPOSITORY != null ? 1 : 0
#     depends_on = [
#         spacelift_environment_variable.env_branch,
#         spacelift_environment_variable.env_repository
#    ]
#     administrative = true
#     autodeploy = true
#     branch = var.ENV_BRANCH
#     description = "Modules"
#     name = "module"
#     project_root = "terraform/module"
#     repository = var.ENV_REPOSITORY
#     terraform_version = "1.5.7"
#     labels = ["module"]
# }

