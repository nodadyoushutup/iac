resource "spacelift_module" "stack" {
    administrative = false
    branch = var.GIT_BRANCH
    description = "Spacelift stack"
    enable_local_preview = false
    labels = ["spacelift"]
    name = "stack"
    project_root = "terraform/module/spacelift/stack"
    public = true
    repository = var.GIT_REPOSITORY
    shared_accounts = null
    space_id = data.spacelift_space.root.id
    terraform_provider = "spacelift"
    workflow_tool = "TERRAFORM_FOSS"
}

resource "spacelift_stack" "spacelift_infra" {
    depends_on = [
        data.spacelift_environment_variable.git_branch,
        data.spacelift_environment_variable.git_repository,
   ]
    administrative = true
    autodeploy = true
    branch = var.GIT_BRANCH
    description = "Spacelift stack management"
    name = "spacelift_infra"
    project_root = "terraform/stack/spacelift_infra"
    repository = var.GIT_REPOSITORY
    terraform_version = "1.5.7"
    labels = ["module"]
    additional_project_globs = ["script/**"]
}

