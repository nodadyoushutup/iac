data "spacelift_stack" "spacelift" {
  stack_id = "spacelift"
}

data "external" "validate_env" {
    program = [
        "bash", 
        "${path.module}/validate_env.sh", 
        local.config.path.private_key, 
        local.config.path.gitconfig, 
        local.config.path.inventory,
        local.config.path.env
    ]
    query = {trigger = random_id.trigger.hex}
    depends_on = [random_id.trigger]
}