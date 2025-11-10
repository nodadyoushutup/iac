data "terraform_remote_state" "app" {
  backend = "s3"
  config = merge(
    var.remote_state_backend,
    {
      key = "nginx-proxy-manager-app.tfstate"
    },
  )
}

module "nginx_proxy_manager_config" {
  source = "../../../module/nginx_proxy_manager/config"

  provider_config = var.provider_config
  config          = var.config
  app_state       = data.terraform_remote_state.app.outputs
}
