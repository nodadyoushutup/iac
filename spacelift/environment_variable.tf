resource "spacelift_environment_variable" "log_level_terraform" {
  context_id  = "config"
  name        = "TF_LOG"
  value       = try(local.config.global.log_level.terraform, "info")
  write_only  = false
  description = "Teraform log level"
  depends_on = [spacelift_context.config]
}

resource "spacelift_environment_variable" "log_level_ansible" {
  context_id  = "config"
  name        = "ANSIBLE_LOG_VERBOSITY"
  value       = try(local.config.global.log_level.ansible, 0)
  write_only  = false
  description = "Ansible log level"
  depends_on = [spacelift_context.config]
}