module "docker_infra" {
    source  = "spacelift.io/nodadyoushutup/stack/spacelift"
    branch = coalesce(var.GIT_BRANCH, "main")
    name = "docker_infra"
    project_root = "terraform/docker"
    repository = coalesce(var.GIT_REPOSITORY, "iac")
    terraform_version = "1.5.7"
}