# # module
# module "test_stack" {
#     source  = "spacelift.io/nodadyoushutup/stack/spacelift"
#     count = local.env > 0 ? 1 : 0
    
#     branch = coalesce(try(local.config.spacelift.stack.branch, null), "main")
#     name = "test"
#     project_root = "terraform/docker"
#     repository = coalesce(try(local.config.spacelift.stack.repository, null), "iac")
#     terraform_version = "1.5.7"
# }