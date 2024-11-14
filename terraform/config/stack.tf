
resource "spacelift_stack" "module" {
    count = var.FLAG_CONFIG >=1 && var.GIT_BRANCH != null && var.GIT_REPOSITORY != null ? 1 : 0
    depends_on = [
        spacelift_environment_variable.git_branch,
        spacelift_environment_variable.git_repository,
        spacelift_environment_variable.flag_config
   ]
    administrative = true
    autodeploy = true
    branch = var.BRANCH
    description = "Modules"
    name = "module"
    project_root = "terraform/module"
    repository = var.REPOSITORY
    terraform_version = "1.5.7"
    labels = ["module"]
}

