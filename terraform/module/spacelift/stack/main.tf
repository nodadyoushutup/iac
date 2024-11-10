resource "spacelift_stack" "stack" {
    # REQUIRED
    branch = try(var.branch, local.config.spacelift.stack.branch)
    name = "stack"
    repository = "iac"

    # OPTIONAL
    administrative = true
    autodeploy = true
    description = "Spacelift stack"
    project_root = "terraform"
    space_id = "root"
    terraform_version = "1.5.7"
    labels = []
}