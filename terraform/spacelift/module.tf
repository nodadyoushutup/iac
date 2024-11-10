resource "spacelift_module" "spacelift_stack_terraform" {
    # REQUIRED
    branch = "main"
    repository = "iac"

    # OPTIONAL
    administrative = false
    description = "Spacelift Terraform stack"
    enable_local_preview = false
    labels = ["spacelift", "infra", "terraform"]
    name = "stack"
    project_root = "module/spacelift/stack/terraform"
    public = true
    shared_accounts = null
    space_id = "root"
    terraform_provider = "spacelift"
    workflow_tool = "TERRAFORM_FOSS"
}