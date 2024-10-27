### MOUNTED FILE ###
resource "spacelift_mounted_file" "config_mounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = "config.yaml"
    content = local.base64.config
    write_only = false
}

resource "spacelift_mounted_file" "private_keymounted_file" {
    depends_on = [spacelift_context_attachment.spacelift_config_context_attachment]
    context_id = spacelift_context.config_context.id
    relative_path = "id_rsa"
    content = local.base64.private_key
    write_only = true
}