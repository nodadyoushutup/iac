resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${local.config.datapath} > ./config.sub.yaml"
    ]
}