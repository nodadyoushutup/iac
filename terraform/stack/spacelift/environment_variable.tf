resource "spacelift_environment_variable" "FLAG_VALID_CONFIG" { 
    count = var.FLAG_DEPLOY >= 1 ? 1 : 0
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_FLAG_VALID_CONFIG" 
    value       = data.external.validate[0].result["valid"] == "true" ? var.FLAG_VALID_CONFIG + 1 : 0
    write_only  = false 
    description = "Valid configuration"
}

resource "spacelift_environment_variable" "FLAG_DEPLOY" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_FLAG_DEPLOY" 
    value       = local.flag.deploy
    write_only  = false 
    description = "Deployment ID"
}

resource "spacelift_environment_variable" "CONFIG_PATH" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_CONFIG_PATH" 
    value       = local.config_path
    write_only  = false 
    description = "Configuration path"
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