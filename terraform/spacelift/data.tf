data "spacelift_stack" "spacelift" {
  stack_id = "spacelift"
}

data "external" "private_key_validation" {
    program = ["bash", "${path.module}/private_key_validation.sh", local.config.path.private_key]
    query = {trigger = random_id.trigger.hex}
    depends_on = [random_id.trigger]
}