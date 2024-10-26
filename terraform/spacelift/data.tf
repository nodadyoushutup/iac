data "spacelift_stack" "spacelift" {
  stack_id = "spacelift"
}

resource "random_id" "validate_env_trigger" {
    byte_length = 8
}

data "external" "validate_private_key" {
    program = [
        "bash", 
        "${path.module}/script/validate_private_key.sh", 
        local.config.spacelift.path.private_key
    ]
    query = {trigger = random_id.validate_env_trigger.hex}
    depends_on = [random_id.validate_env_trigger]
}

data "external" "validate_gitconfig" {
    program = [
        "bash", 
        "${path.module}/script/validate_gitconfig.sh", 
        local.config.spacelift.path.gitconfig
    ]
    query = {trigger = random_id.validate_env_trigger.hex}
    depends_on = [random_id.validate_env_trigger]
}

data "external" "validate_ansible_inventory" {
    program = [
        "bash", 
        "${path.module}/script/validate_ansible_inventory.sh", 
        local.config.spacelift.path.ansible.inventory
    ]
    query = {trigger = random_id.validate_env_trigger.hex}
    depends_on = [random_id.validate_env_trigger]
}

data "external" "validate_docker_env" {
    program = [
        "bash", 
        "${path.module}/script/validate_docker_env.sh", 
        local.config.spacelift.path.docker.env
    ]
    query = {trigger = random_id.validate_env_trigger.hex}
    depends_on = [random_id.validate_env_trigger]
}