resource "spacelift_stack" "stack" {
    # REQUIRED
    branch = "main"
    name = "stack"
    repository = "iac"
    space_id = "root"

    # OPTIONAL
    administrative = true
    autodeploy = true
    description = "Spacelift stack"
    project_root = "terraform"
    terraform_version = "1.5.7"
    labels = []
}