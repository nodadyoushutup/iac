resource "spacelift_environment_variable" "FLAG_DEPLOY" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_FLAG_DEPLOY" 
    value       = local.flag.deploy
    write_only  = false 
    description = "Deployment ID"
}

resource "spacelift_environment_variable" "CONFIG_PATH_CONFIG" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_CONFIG_PATH_CONFIG" 
    value       = local.config.path
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

resource "spacelift_environment_variable" "DEFAULT_PUBLIC_KEY_DIR" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_DEFAULT_PUBLIC_KEY_DIR" 
    value       = local.default.public_key_dir
    write_only  = false 
    description = "Public SSH keys directory path"
}

resource "spacelift_environment_variable" "DEFAULT_USERNAME" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_DEFAULT_USERNAME" 
    value       = local.default.username
    write_only  = true 
    description = "Default username"
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

resource "spacelift_environment_variable" "SPACELIFT_RUNNER_IMAGE" { 
    depends_on = [spacelift_context.config]
    context_id  = spacelift_context.config.id
    name        = "TF_VAR_SPACELIFT_RUNNER_IMAGE" 
    value       = local.spacelift.runner_image
    write_only  = false 
    description = "Spacelift runner image"
}