resource "spacelift_context" "spacectl" {
    name = "spacectl"
    description = "Runner Spacectl CLI"
    space_id = data.spacelift_space.root.id
    after_apply = [
        "python3 ${path.module}/script/after_apply.py"
    ]
}

resource "spacelift_context_attachment" "spacectl_module" {
    depends_on = [
        spacelift_context.spacectl,
        data.spacelift_stack.module
    ]
    context_id = spacelift_context.spacectl.id
    stack_id   = spacelift_stack.module[0].id
    priority   = 0
}

resource "spacelift_module" "stack" {
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

resource "spacelift_stack" "spacelift" {
    count = var.FLAG_MODULE >=1 ? 1 : 0
    depends_on = [
        data.spacelift_environment_variable.git_branch,
        data.spacelift_environment_variable.git_repository,
        spacelift_environment_variable.flag_module
   ]
    administrative = true
    autodeploy = true
    branch = var.GIT_BRANCH
    description = "Spacelift stack management"
    name = "spacelift"
    project_root = "terraform/stack/spacelift"
    repository = var.GIT_REPOSITORY
    terraform_version = "1.5.7"
    labels = ["module"]
    additional_project_globs = ["script/**"]
}

