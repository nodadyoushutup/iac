resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${local.config_path} > ./config.sub.yaml",
        "cat ./config.sub.yaml"
    ]
}