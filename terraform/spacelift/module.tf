# module
module "test_stack" {
    source  = "spacelift.io/nodadyoushutup/stack/spacelift"
    name = "test"
    branch = "main"
    repository = "iac"
}