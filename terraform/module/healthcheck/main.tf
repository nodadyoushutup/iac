locals {
  environment = merge(
    {
      MAX_ATTEMPTS = tostring(var.max_attempts)
      TIMEOUT      = tostring(var.timeout_seconds)
      STATUS_RANGE = var.status_range
    },
    var.curl_insecure ? { CURL_INSECURE = "1" } : {},
    var.quiet ? { QUIET = "1" } : {},
    var.environment
  )

  triggers = merge(
    {
      endpoint      = var.endpoint
      delay_seconds = tostring(var.delay_seconds)
      script_sha    = filebase64sha256("${path.module}/healthcheck.sh")
      max_attempts  = tostring(var.max_attempts)
      timeout       = tostring(var.timeout_seconds)
      status_range  = var.status_range
      curl_insecure = tostring(var.curl_insecure)
      quiet         = tostring(var.quiet)
    },
    var.triggers
  )
}

resource "null_resource" "healthcheck" {
  triggers = local.triggers

  provisioner "local-exec" {
    environment = local.environment
    command     = format("bash %s %s %s", "${path.module}/healthcheck.sh", jsonencode(var.endpoint), tostring(var.delay_seconds))
  }
}
