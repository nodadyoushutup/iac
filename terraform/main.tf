module "jenkins_controller" {
  # source = "./module/app/controller"
  source = "github.com/nodadyoushutup/jenkins//terraform/module/app/controller?ref=main"

  casc_config = var.casc_config
  healthcheck_endpoint = format("%s/whoAmI/api/json?tree=authenticated", var.provider_config.jenkins.server_url)
}

module "jenkins_agent" {
  # source = "./module/app/agent"
  source = "github.com/nodadyoushutup/jenkins//terraform/module/app/agent?ref=main"

  depends_on = [module.jenkins_controller]
  for_each = { for node in var.casc_config.jenkins.nodes : node.permanent.name => node }
  
  name = each.value.permanent.name
  jenkins_url = var.provider_config.jenkins.server_url
}