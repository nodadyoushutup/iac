resource "spacelift_module" "spacelift_stack" {
    # REQUIRED
    branch = coalesce(var.GIT_BRANCH, "main")
    repository = coalesce(var.GIT_REPOSITORY, "iac")

    # OPTIONAL
    administrative = false
    description = "Spacelift stack"
    enable_local_preview = false
    labels = ["spacelift"]
    name = "stack"
    project_root = "terraform/module/spacelift/stack"
    public = true
    shared_accounts = null
    space_id = "root"
    terraform_provider = "spacelift"
    workflow_tool = "TERRAFORM_FOSS"
}

resource "spacelift_environment_variable" "flag_module" { 
    context_id  = data.spacelift_context.config.id
    name        = "TF_VAR_FLAG_MODULE" 
    value       = local.flag.module
    write_only  = false 
    description = "Deployment ID"
}

resource "spacelift_stack" "stack" {
    count = var.FLAG_MODULE >=1 && var.GIT_BRANCH != null && var.GIT_REPOSITORY != null ? 1 : 0
    depends_on = [
        spacelift_environment_variable.GIT_BRANCH,
        spacelift_environment_variable.GIT_REPOSITORY,
        spacelift_environment_variable.flag_module
   ]
    administrative = true
    autodeploy = true
    branch = var.GIT_BRANCH
    description = "Stacks"
    name = "stack"
    project_root = "terraform/spacelift"
    repository = var.GIT_REPOSITORY
    terraform_version = "1.5.7"
    labels = ["module"]
    additional_project_globs = ["script/**"]
}

