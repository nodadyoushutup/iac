data "spacelift_stack" "config" {
  stack_id = "config"
}

resource "random_id" "validate_env_trigger" {
    byte_length = 8
}

data "external" "validate_env" {
    program = [
        "python3",
        "${path.module}/script/validate_config.py"
    ]
    query = { trigger = random_id.validate_env_trigger.hex }
    depends_on = [random_id.validate_env_trigger]
}

output "validate_config" {
  value = data.external.validate_env.result["valid"]
}

output "validate_private_key" {
  value = data.external.validate_env.result["private_key"]
}