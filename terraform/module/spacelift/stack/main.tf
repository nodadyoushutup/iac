resource "spacelift_stack" "stack" {
    # REQUIRED
    branch = var.branch
    name = var.name
    repository = var.repository

    # OPTIONAL
    administrative = var.administrative
    autodeploy = var.autodeploy
    description = var.description
    labels = var.labels
    project_root = var.project_root
    space_id = "root"

    # TERRAFORM
    terraform_version = var.terraform_version
}
