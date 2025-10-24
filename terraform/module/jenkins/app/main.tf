module "controller" {
  source = "./controller"

  casc_config     = var.casc_config
  provider_config = var.provider_config
  mounts          = var.mounts
}

module "agents" {
  source     = "./agent"
  for_each   = { for node in try(var.casc_config.jenkins.nodes, []) : node.permanent.name => node }
  depends_on = [module.controller]

  name            = each.value.permanent.name
  provider_config = var.provider_config
  mounts          = var.mounts
}
