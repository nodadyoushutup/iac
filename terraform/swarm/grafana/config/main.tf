module "grafana_config" {
  source = "../../../module/grafana/config"

  grafana_config_inputs = var.grafana_config_inputs
  folders               = var.folders
  datasources           = var.datasources
  dashboards            = var.dashboards
}
