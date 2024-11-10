resource "spacelift_module" "spacelift_stack_terraform" {
    # REQUIRED
    branch = "main"
    repository = "iac"

    # OPTIONAL
    administrative = false
    description = "Spacelift Terraform stack"
    enable_local_preview = false
    labels = ["spacelift", "infra", "terraform"]
    name = "stack-terraform"
    project_root = "terraform/module/stack/terraform"
    public = true
    shared_accounts = null
    space_id = "root"
    terraform_provider = "spacelift"
    workflow_tool = "TERRAFORM_FOSS"
}

resource "spacelift_stack" "module_spacelift_stack_stack" {
    depends_on = [spacelift_module.spacelift_stack_terraform]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Module spacelift stack"
    name = "module_spacelift_stack"
    project_root = "terraform/module/stack/terraform"
    repository = "iac"
    terraform_version = "1.5.7"
    labels = ["module"]
}