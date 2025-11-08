module "node_exporter_app" {
  source = "../../module/node_exporter"

  provider_config = var.provider_config
}
