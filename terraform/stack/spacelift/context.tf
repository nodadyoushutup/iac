resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${path.module}/config/config.yaml > /mnt/workspace/config.yaml",
        "cat /mnt/workspace/config.yaml"
    ]
}