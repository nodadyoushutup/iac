resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${local.config_path} > ${local.config_path}",
        "cat ${local.config_path}",
        "echo 'Configuration init complete'"
    ]
}