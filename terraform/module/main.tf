resource "spacelift_module" "spacelift_stack_terraform" {
    # REQUIRED
    branch = "main"
    repository = "iac"

    # OPTIONAL
    administrative = false
    description = "Spacelift Terraform stack"
    enable_local_preview = false
    labels = ["spacelift", "infra", "terraform"]
    name = "stack"
    project_root = "module/spacelift/stack/terraform"
    public = true
    shared_accounts = null
    space_id = "root"
    terraform_provider = "spacelift"
    workflow_tool = "TERRAFORM_FOSS"
}

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

