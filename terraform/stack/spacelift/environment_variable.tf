# resource "spacelift_environment_variable" "flag_config" { 
#     depends_on = [spacelift_context.config]
#     context_id  = spacelift_context.config.id
#     name        = "TF_VAR_FLAG_CONFIG" 
#     value       = local.flag.config
#     write_only  = false 
#     description = "Valid configuration"
# }

# resource "spacelift_environment_variable" "flag_deploy" { 
#     depends_on = [spacelift_context.config]
#     context_id  = spacelift_context.config.id
#     name        = "TF_VAR_FLAG_DEPLOY" 
#     value       = local.flag.deploy
#     write_only  = false 
#     description = "Deployment ID"
# }

resource "spacelift_environment_variable" "DEFAULT_PRIVATE_KEY" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_DEFAULT_PRIVATE_KEY" 
    value       = local.default.private_key
    write_only  = false 
    description = "Default private key"
}

resource "spacelift_environment_variable" "DEFAULT_PASSWORD" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_DEFAULT_PASSWORD" 
    value       = local.default.password
    write_only  = true 
    description = "Default password"
}

resource "spacelift_environment_variable" "DEFAULT_IP_ADDRESS" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_DEFAULT_IP_ADDRESS" 
    value       = local.default.ip_address
    write_only  = true 
    description = "Default IP Address"
}

resource "spacelift_environment_variable" "GITHUB_BRANCH" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_GITHUB_BRANCH" 
    value       = local.github.branch
    write_only  = false 
    description = "Github branch"
}

resource "spacelift_environment_variable" "GITHUB_REPOSITORY" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_GITHUB_REPOSITORY" 
    value       = local.github.repository
    write_only  = false 
    description = "Github repository"
}

