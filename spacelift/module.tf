# resource "spacelift_module" "proxmox_virtual_machine" {
#     name = "virtual_machine"
#     terraform_provider = "proxmox"
#     administrative = false
#     branch = "main"
#     description = "Virtual Machine"
#     repository = "module"
#     project_root = "proxmox/virtual_machine"
#     labels = ["infra", "proxmox"]
#     github_enterprise { 
#         namespace = "nodadyoushutup-iac"
#     }
# }

# resource "spacelift_module" "fortigate_vip" {
#     name               = "vip"
#     terraform_provider = "fortigate"
#     administrative     = false
#     branch             = "main"
#     description        = "Fortigate Firewall Virtual IP"
#     repository         = "module"
#     project_root       = "fortigate/vip"
#     labels             = ["config", "fortigate"]
#     github_enterprise { 
#         namespace = "nodadyoushutup-iac"
#     }   
# }

# resource "spacelift_module" "fortigate_policy" {
#     name               = "policy"
#     terraform_provider = "fortigate"
#     administrative     = false
#     branch             = "main"
#     description        = "Fortigate Firewall Policy"
#     repository         = "module"
#     project_root       = "fortigate/policy"
#     labels             = ["config", "fortigate"]
#     github_enterprise { 
#         namespace = "nodadyoushutup-iac"
#     }
# }

# resource "spacelift_module" "fortigate_port_forward" {
#     name               = "port_forward"
#     terraform_provider = "fortigate"
#     administrative     = false
#     branch             = "main"
#     description        = "Fortigate Port Forward"
#     repository         = "module"
#     project_root       = "fortigate/port_forward"
#     labels             = ["config", "fortigate"]
#     github_enterprise { 
#         namespace = "nodadyoushutup-iac"
#     }
# }

# resource "spacelift_module" "spacelift_stack" {
#     name               = "stack"
#     terraform_provider = "spacelift"
#     administrative     = false
#     branch             = "main"
#     description        = "Spacelift stack"
#     repository         = "module"
#     project_root       = "spacelift/stack"
#     labels             = ["infra", "spacelift"]
#     github_enterprise { 
#         namespace = "nodadyoushutup-iac"
#     }
# }

# resource "spacelift_module" "spacelift_component" {
#     name               = "component"
#     terraform_provider = "spacelift"
#     administrative     = false
#     branch             = "main"
#     description        = "Spacelift component"
#     repository         = "module"
#     project_root       = "spacelift/component"
#     labels             = ["infra", "spacelift"]
#     github_enterprise { 
#         namespace = "nodadyoushutup-iac"
#     }
# }

