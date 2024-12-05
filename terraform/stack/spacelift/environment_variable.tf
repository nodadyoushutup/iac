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



# resource "spacelift_environment_variable" "path_private_key" { 
#     depends_on = [spacelift_context.config]
#     context_id  = spacelift_context.config.id
#     name        = "TF_VAR_PATH_PRIVATE_KEY" 
#     value       = var.PATH_PRIVATE_KEY
#     write_only  = false 
#     description = "Private key"
# }

# resource "spacelift_environment_variable" "path_config" { 
#     depends_on = [spacelift_context.config]
#     context_id  = spacelift_context.config.id
#     name        = "TF_VAR_PATH_CONFIG" 
#     value       = var.PATH_CONFIG
#     write_only  = false 
#     description = "IaC configuration path"
# }



resource "spacelift_environment_variable" "GITHUB_BRANCH" { 
    depends_on = [spacelift_context.github]
    context_id  = spacelift_context.github.id
    name        = "TF_VAR_GITHUB_BRANCH" 
    value       = local.github.branch
    write_only  = false 
    description = "Environment branch"
}

resource "spacelift_environment_variable" "GITHUB_REPOSITORY" { 
    depends_on = [spacelift_context.github]
    context_id  = spacelift_context.github.id
    name        = "TF_VAR_GITHUB_REPOSITORY" 
    value       = local.github.repository
    write_only  = false 
    description = "Environment repository"
}

resource "spacelift_environment_variable" "PROXMOX_VE_ENDPOINT" { 
    depends_on = [spacelift_context.proxmox]
    context_id = spacelift_context.proxmox.id
    name = "TF_VAR_PROXMOX_VE_ENDPOINT"
    value = local.proxmox.endpoint
    write_only = false 
    description = "Proxmox endpoint"
}

resource "spacelift_environment_variable" "PROXMOX_VE_INSECURE" { 
    depends_on = [spacelift_context.proxmox]
    context_id = spacelift_context.proxmox.id
    name = "TF_VAR_PROXMOX_VE_INSECURE"
    value = local.proxmox.insecure
    write_only = false 
    description = "Proxmox insecure"
}

resource "spacelift_environment_variable" "PROXMOX_VE_USERNAME" { 
    depends_on = [spacelift_context.proxmox]
    context_id = spacelift_context.proxmox.id
    name = "TF_VAR_PROXMOX_VE_USERNAME"
    value = local.proxmox.username
    write_only = false 
    description = "Proxmox username"
}

resource "spacelift_environment_variable" "PROXMOX_VE_PASSWORD" { 
    depends_on = [spacelift_context.proxmox]
    context_id = spacelift_context.proxmox.id
    name = "TF_VAR_PROXMOX_VE_PASSWORD"
    value = local.proxmox.password
    write_only = false 
    description = "Proxmox password"
}



