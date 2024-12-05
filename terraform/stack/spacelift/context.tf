resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${local.config_path} > ~/config.yaml",
        "cat /mnt/workspace/config.yaml"
    ]
}