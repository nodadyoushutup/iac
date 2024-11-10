# resource "spacelift_stack" "stack" {
#     # REQUIRED
#     name = var.name
#     project_root = var.project_root

#     # UNIQUE
#     description = var.description
#     labels = var.labels

#     # GENERAL
#     administrative = try(var.administrative, local.config.spacelift.stack.administrative, true)
#     autodeploy = try(var.autodeploy, local.config.spacelift.stack.autodeploy, true)
#     branch = try(var.branch, local.config.spacelift.stack.branch, "main")
#     repository = try(var.repository, local.config.spacelift.stack.repository, "iac")
#     space_id = try(var.space_id, local.config.spacelift.stack.space_id, "root")

#     # TERRAFORM
#     terraform_version = try(var.terraform_version, local.config.spacelift.stack.terraform_version, "1.5.7")
# }



output "okokok" {
  value = try(var.repository, local.config.spacelift.stack.repository, "iac")
}

output "okokok2" {
  value = try(var.repository, local.config.spacelift.stack.repository, "iac")
}