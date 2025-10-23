module "controller" {
  source = "./controller"

  casc_config          = var.casc_config
  healthcheck_endpoint = var.healthcheck_endpoint
  mounts               = var.mounts
}

module "agents" {
  source     = "./agent"
  for_each   = { for node in try(var.casc_config.jenkins.nodes, []) : node.permanent.name => node }
  depends_on = [module.controller]

  name        = each.value.permanent.name
  jenkins_url = var.jenkins_url
}
