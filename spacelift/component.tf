data "spacelift_module" "stack" {
  module_id = "stack"
}

output "stack" {
  value = data.spacelift_module.stack
}

# module "component" {
#   source  = "spacelift.io/nodadyoushutup/component/spacelift"
#   for_each = { for component in local.config.component : component => component }
  
#   component = each.value

#   depends_on = [
#     spacelift_module.spacelift_stack,
#     spacelift_module.spacelift_component,
#     spacelift_module.proxmox_virtual_machine,
#     spacelift_module.fortigate_vip,
#     spacelift_module.fortigate_policy,
#     spacelift_module.fortigate_port_forward,
#   ]
# }