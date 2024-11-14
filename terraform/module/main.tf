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