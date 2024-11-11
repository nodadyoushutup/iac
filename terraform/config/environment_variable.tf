resource "spacelift_environment_variable" "pyvenv" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_PYVENV" 
    value       = local.flag.pyvenv
    write_only  = false 
    description = "Runner Python virtual environment"
}

resource "spacelift_environment_variable" "branch" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_BRANCH" 
    value       = var.BRANCH
    write_only  = false 
    description = "Environment branch"
}

resource "spacelift_environment_variable" "repository" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_REPOSITORY" 
    value       = var.REPOSITORY
    write_only  = false 
    description = "Environment repository"
}

resource "spacelift_environment_variable" "private_key" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_PRIVATE_KEY" 
    value       = var.PRIVATE_KEY
    write_only  = false 
    description = "Private key"
}

resource "spacelift_environment_variable" "config_path" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_CONFIG_PATH" 
    value       = var.CONFIG_PATH
    write_only  = false 
    description = "IaC configuration path"
}



