resource "spacelift_stack" "spacelift_init" {
    count = var.FLAG_CONFIG >=1 && var.GIT_BRANCH != null && var.GIT_REPOSITORY != null ? 1 : 0
    depends_on = [
        spacelift_environment_variable.git_branch,
        spacelift_environment_variable.git_repository,
        spacelift_environment_variable.flag_config
   ]
    administrative = true
    autodeploy = true
    branch = var.GIT_BRANCH
    description = "Spacelift module init"
    name = "spacelift_init"
    project_root = "terraform/stack/spacelift_init"
    repository = var.GIT_REPOSITORY
    terraform_version = "1.5.7"
    labels = ["spacelift", "init"]
    additional_project_globs = [ 
        "script/**",
        "bin/**"
    ]
}

