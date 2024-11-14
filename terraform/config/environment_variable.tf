resource "spacelift_environment_variable" "flag_config" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_FLAG_CONFIG" 
    value       = local.flag.config
    write_only  = false 
    description = "Valid configuration"
}

resource "spacelift_environment_variable" "flag_deploy" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_FLAG_DEPLOY" 
    value       = local.flag.deploy
    write_only  = false 
    description = "Deployment ID"
}

resource "spacelift_environment_variable" "git_branch" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_GIT_BRANCH" 
    value       = local.git.branch
    write_only  = false 
    description = "Environment branch"
}

resource "spacelift_environment_variable" "git_repository" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_GIT_REPOSITORY" 
    value       = local.git.repository
    write_only  = false 
    description = "Environment repository"
}

resource "spacelift_environment_variable" "path_private_key" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_PATH_PRIVATE_KEY" 
    value       = var.PATH_PRIVATE_KEY
    write_only  = false 
    description = "Private key"
}

resource "spacelift_environment_variable" "path_config" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_PATH_CONFIG" 
    value       = var.PATH_CONFIG
    write_only  = false 
    description = "IaC configuration path"
}



