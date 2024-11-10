# # module
# module "test_stack" {
#     source  = "spacelift.io/nodadyoushutup/stack/spacelift"
#     name = "test"
#     branch = "main"
#     repository = "iac"
#     project_root = "terraform/docker"
#     raw_git = {
#         namespace = "nodadyoushutup"
#         url = "https://github.com/nodadyoushutup/iac"
#     }
#     ansible = {
#         playbook = "main.yaml"
#     }
# }