resource "spacelift_context" "env_context" {
    description = "Environment"
    name = "env"
    space_id = "root"
}

resource "spacelift_environment_variable" "env_branch" { 
    depends_on = [ spacelift_context.env_context ]
    context_id  = spacelift_context.env_context.id
    name        = "TF_VAR_ENV_BRANCH" 
    value       = var.ENV_BRANCH
    write_only  = false 
    description = "Environment branch"
}

resource "spacelift_environment_variable" "env_repository" { 
    depends_on = [ spacelift_context.env_context ]
    context_id  = spacelift_context.env_context.id
    name        = "TF_VAR_ENV_REPOSITORY" 
    value       = var.ENV_REPOSITORY
    write_only  = false 
    description = "Environment repository"
}

resource "spacelift_context_attachment" "env_context_attachment" {
    depends_on = [ 
        spacelift_context.env_context,
        spacelift_environment_variable.env_branch,
        spacelift_environment_variable.env_repository
    ]
    context_id = spacelift_context.env_context.id
    stack_id   = data.spacelift_stack.env.id
    priority   = 0
}

resource "spacelift_stack" "module" {
    count = var.ENV_BRANCH != null && var.ENV_REPOSITORY != null ? 1 : 0
    depends_on = [ 
        spacelift_environment_variable.env_branch,
        spacelift_environment_variable.env_repository
    ]
    administrative = true
    autodeploy = true
    branch = var.ENV_BRANCH
    description = "Modules"
    name = "module"
    project_root = "terraform/module"
    repository = var.ENV_REPOSITORY
    terraform_version = "1.5.7"
    labels = ["module"]
}

