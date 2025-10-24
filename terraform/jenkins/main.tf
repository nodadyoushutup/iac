module "jenkins_app" {
  source = "../module/jenkins/app"

  casc_config          = var.casc_config
  healthcheck_endpoint = format("%s/whoAmI/api/json?tree=authenticated", var.provider_config.jenkins.server_url)
  jenkins_url          = var.provider_config.jenkins.server_url
  mounts               = var.mounts
}

module "jenkins_config" {
  source = "../module/jenkins/config"

  depends_on = [module.jenkins_app]
}
