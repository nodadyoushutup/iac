# module
module "test_stack" {
    source  = "spacelift.io/${spacelift_account_name}/stack/spacelift"
    name = "test"
    branch = "main"
    repository = "iac"
    project_root = "terraform/docker"
    terraform_version = "1.5.7"
}