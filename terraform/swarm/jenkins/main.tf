module "jenkins_app" {
  source = "../../module/jenkins/app"

  casc_config     = var.casc_config
  provider_config = var.provider_config
  mounts          = var.mounts
  env             = var.env
}

module "jenkins_config" {
  source = "../../module/jenkins/config"

  depends_on = [module.jenkins_app]
}
