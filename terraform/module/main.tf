resource "spacelift_module" "module_stack" {
    # REQUIRED
    branch = "main"
    repository = "iac"

    # OPTIONAL
    administrative = false
    description = "Spacelift Terraform stack"
    enable_local_preview = false
    labels = ["spacelift", "infra", "terraform"]
    name = "stack"
    project_root = "terraform/module/stack/terraform"
    public = true
    shared_accounts = null
    space_id = "root"
    terraform_provider = "spacelift"
    workflow_tool = "TERRAFORM_FOSS"
}

resource "spacelift_stack" "module_stack_stack" {
    depends_on = [spacelift_module.module_stack]
    administrative = true
    autodeploy = true
    branch = "main"
    description = "Module spacelift stack"
    name = "module_spacelift_stack"
    project_root = "terraform/module/stack"
    repository = "iac"
    terraform_version = "1.5.7"
    labels = ["module"]
}