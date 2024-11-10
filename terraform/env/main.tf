resource "spacelift_context" "env_context" {
    description = "Environment"
    name = "env"
    space_id = "root"
}

resource "spacelift_environment_variable" "env_branch" { 
    context_id  = spacelift_context.env_context.id
    name        = "TF_VAR_ENV_BRANCH" 
    value       = var.ENV_BRANCH
    write_only  = false 
    description = "Environment branch"
}

resource "spacelift_environment_variable" "env_repository" { 
    context_id  = spacelift_context.env_context.id
    name        = "TF_VAR_ENV_REPOSITORY" 
    value       = var.ENV_REPOSITORY
    write_only  = false 
    description = "Environment repository"
}