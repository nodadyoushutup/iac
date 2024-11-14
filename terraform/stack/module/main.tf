resource "spacelift_module" "stack" {
    # REQUIRED
    branch = var.GIT_BRANCH
    repository = var.GIT_REPOSITORY

    # OPTIONAL
    administrative = false
    description = "Spacelift stack"
    enable_local_preview = false
    labels = ["spacelift"]
    name = "stack"
    project_root = "terraform/module/spacelift/stack"
    public = true
    shared_accounts = null
    space_id = data.spacelift_space.root.id
    terraform_provider = "spacelift"
    workflow_tool = "TERRAFORM_FOSS"
}

resource "spacelift_stack" "spacelift" {
    depends_on = [
        data.spacelift_environment_variable.git_branch,
        data.spacelift_environment_variable.git_repository,
   ]
    administrative = true
    autodeploy = true
    branch = var.GIT_BRANCH
    description = "Spacelift stack management"
    name = "stack"
    project_root = "terraform/stack/stack"
    repository = var.GIT_REPOSITORY
    terraform_version = "1.5.7"
    labels = ["module"]
    additional_project_globs = ["script/**"]
}

