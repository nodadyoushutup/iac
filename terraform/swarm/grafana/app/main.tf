module "grafana_app" {
  source = "../../../module/grafana/app"

  provider_config = var.provider_config
}
