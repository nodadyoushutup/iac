data "spacelift_stack" "spacelift" {
  stack_id = "spacelift"
}

resource "random_id" "trigger" {
    byte_length = 8
}

data "external" "validate_env" {
    program = [
        "bash", 
        "${path.module}/validate_env.sh", 
        local.config.path.private_key, 
        local.config.path.gitconfig, 
        local.config.path.ansible.inventory,
        local.config.path.docker.env
    ]
    query = {trigger = random_id.trigger.hex}
    depends_on = [random_id.trigger]
}