resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${local.config.path} > ./config.sub.yaml",
        "chmod 600 ${local.default.private_key}",
        "mkdir -p ~/.ssh"
        # "ssh-keyscan -p ${local.config.data.development.port.external} ${local.config.data.default.ip_address} >> ~/.ssh/known_hosts"
    ]
}