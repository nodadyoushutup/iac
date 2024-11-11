
# resource "spacelift_stack" "module" {
#     count = var.BRANCH != null && var.REPOSITORY != null ? 1 : 0
#     depends_on = [
#         spacelift_environment_variable.branch,
#         spacelift_environment_variable.repository
#    ]
#     administrative = true
#     autodeploy = true
#     branch = var.BRANCH
#     description = "Modules"
#     name = "module"
#     project_root = "terraform/module"
#     repository = var.REPOSITORY
#     terraform_version = "1.5.7"
#     labels = ["module"]
# }

