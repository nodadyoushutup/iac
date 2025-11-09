module "controller" {
  source = "../../../module/jenkins/app/controller"

  casc_config     = var.casc_config
  provider_config = var.provider_config
  mounts          = var.mounts
  env             = var.env
}
