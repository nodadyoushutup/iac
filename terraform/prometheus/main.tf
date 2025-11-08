module "prometheus_app" {
  source = "../module/prometheus"

  provider_config   = var.provider_config
  prometheus_config = var.prometheus_config
}
