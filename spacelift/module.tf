# module "component" {
#   source  = "spacelift.io/nodadyoushutup/component/spacelift"
#   for_each = { for component in local.config.component : component => component }
  
#   github_enterprise = null
#   component = each.value
#   repository = "iac"
# }