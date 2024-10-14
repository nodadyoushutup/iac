### ENVIRONMENT VARIABLE ###
resource "spacelift_environment_variable" "tf_log" {
  context_id  = "config"
  name        = "TF_LOG"
  value       = "debug"
  write_only  = false
  description = "Terraform log level"
}