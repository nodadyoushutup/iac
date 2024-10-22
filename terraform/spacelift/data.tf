data "spacelift_stack" "spacelift" {
  stack_id = "spacelift"
}

resource "random_id" "validate_env_trigger" {
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
    query = {trigger = random_id.validate_env_trigger.hex}
    depends_on = [random_id.validate_env_trigger]
}

data "external" "validate_private_key" {
    program = [
        "bash", 
        "${path.module}/validate_private_key.sh", 
        local.config.path.private_key
    ]
    query = {trigger = random_id.validate_env_trigger.hex}
    depends_on = [random_id.validate_env_trigger]
}

data "external" "validate_gitconfig" {
    program = [
        "bash", 
        "${path.module}/validate_gitconfig.sh", 
        local.config.path.gitconfig
    ]
    query = {trigger = random_id.validate_env_trigger.hex}
    depends_on = [random_id.validate_env_trigger]
}