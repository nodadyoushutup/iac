# resource "spacelift_module" "proxmox_virtual_machine" {
#     name = "virtual_machine"
#     terraform_provider  = "proxmox"
#     administrative      = false
#     branch              = "main"
#     description         = "Virtual Machine"
#     repository          = "iac"
#     project_root        = "module/proxmox/virtual_machine"
#     labels              = ["infra", "proxmox"]
# }

# resource "spacelift_module" "fortigate_vip" {
#     name                = "vip"
#     terraform_provider  = "fortigate"
#     administrative      = false
#     branch              = "main"
#     description         = "Fortigate Firewall Virtual IP"
#     repository          = "iac"
#     project_root        = "module/fortigate/vip"
#     labels              = ["config", "fortigate"] 
# }

# resource "spacelift_module" "fortigate_policy" {
#     name                = "policy"
#     terraform_provider  = "fortigate"
#     administrative      = false
#     branch              = "main"
#     description         = "Fortigate Firewall Policy"
#     repository          = "iac"
#     project_root        = "module/fortigate/policy"
#     labels              = ["config", "fortigate"]
# }

# resource "spacelift_module" "fortigate_port_forward" {
#     name                = "port_forward"
#     terraform_provider  = "fortigate"
#     administrative      = false
#     branch              = "main"
#     description         = "Fortigate Port Forward"
#     repository          = "iac"
#     project_root        = "module/fortigate/port_forward"
#     labels              = ["config", "fortigate"]
# }

# resource "spacelift_module" "spacelift_stack" {
#     name                = "stack"
#     terraform_provider  = "spacelift"
#     administrative      = false
#     branch              = "main"
#     description         = "Spacelift stack"
#     repository          = "iac"
#     project_root        = "module/spacelift/stack"
#     labels              = ["infra", "spacelift"]
# }

# resource "spacelift_module" "spacelift_component" {
#     name                = "component"
#     terraform_provider  = "spacelift"
#     administrative      = false
#     branch              = "main"
#     description         = "Spacelift component"
#     repository          = "iac"
#     project_root        = "module/spacelift/component"
#     labels              = ["infra", "spacelift"]
# }

locals {
  stack_exists = contains([for stack in data.spacelift_module.stack : stack], "stack")
}

resource "null_resource" "placeholder" {
  count = local.stack_exists ? 0 : 1
}

output "stack_data" {
  value = local.stack_exists ? data.spacelift_module.stack : {}
}