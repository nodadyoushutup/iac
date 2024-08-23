# resource "spacelift_environment_variable" "log_level_terraform" {
#   context_id  = "config"
#   name        = "TF_LOG"
#   value       = try(local.config.global.log_level.terraform, "info")
#   write_only  = false
#   description = "Log level"
# }

# resource "spacelift_environment_variable" "log_level_ansible" {
#   context_id  = "config"
#   name        = "ANSIBLE_LOG_VERBOSITY"
#   value       = try(local.config.global.log_level.ansible, 0)
#   write_only  = false
#   description = "Log level"
# }