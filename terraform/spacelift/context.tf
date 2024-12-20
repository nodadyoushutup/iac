resource "spacelift_context" "config" {
    name = "config"
    description = "Configuration"
    space_id = "root"
    before_init = [
        "envsubst < ${local.config.path} > ./config.sub.yaml",
        "chmod 600 ${local.default.private_key}",
    ]
}

resource "spacelift_context" "virtual_machine" {
    name = "virtual_machine"
    description = "Virtual machine"
    space_id = "root"
    after_init = [
        "terraform state rm linux_file.test"
    ]
}