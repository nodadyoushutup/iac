module "grafana_app" {
  source = "../../module/grafana/app"

  provider_config = var.provider_config
}

module "grafana_config" {
  source = "../../module/grafana/config"

  depends_on = [module.grafana_app]

  grafana_config_inputs = var.grafana_config_inputs
}
