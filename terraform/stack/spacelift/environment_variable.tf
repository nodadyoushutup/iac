# resource "spacelift_environment_variable" "flag_deploy" { 
#     depends_on = [spacelift_context.config]
#     context_id  = spacelift_context.config.id
#     name        = "TF_VAR_FLAG_DEPLOY" 
#     value       = local.flag.deploy
#     write_only  = false 
#     description = "Deployment ID"
# }

resource "spacelift_environment_variable" "FLAG_VALID_CONFIG" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_FLAG_VALID_CONFIG" 
    value       = local.flag.valid_config
    write_only  = false 
    description = "Valid configuration"
}

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