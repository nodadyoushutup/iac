resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${local.config.path} > ./config.sub.yaml",
        "chmod 600 ${local.default.private_key}",
    ]
}