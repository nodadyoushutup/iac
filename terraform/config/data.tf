data "spacelift_space" "root" {
  space_id = "root"
}

data "spacelift_stack" "config" {
  stack_id = "config"
}

resource "random_id" "validate_env_trigger" {
  count = var.FLAG_DEPLOY >= 1 ? 1 : 0
  byte_length = 8
}

data "external" "validate_env" {
  count = var.FLAG_DEPLOY >= 1 ? 1 : 0
  depends_on = [random_id.validate_env_trigger]
  program = [
      "python3",
      "${path.module}/script/validate_config.py"
  ]
  query = { trigger = random_id.validate_env_trigger[count.index].hex }
}

