# resource "spacelift_mounted_file" "config_mounted_file" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id = spacelift_context.config[count.index].id
#     relative_path = "config.yaml"
#     content = local.base64.config
#     write_only = false
# }

# resource "spacelift_mounted_file" "private_keymounted_file" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context_attachment.config_config]
#     context_id = spacelift_context.config[count.index].id
#     relative_path = "id_rsa"
#     content = local.base64.private_key
#     write_only = true
# }
