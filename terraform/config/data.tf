data "spacelift_space" "root" {
  space_id = "root"
}

data "spacelift_stack" "config" {
  stack_id = "config"
}

data "spacelift_stack" "module" {
  stack_id = "module"
}

resource "random_id" "trigger" {
  count = var.FLAG_DEPLOY >= 1 ? 1 : 0
  byte_length = 8
}

data "external" "validate" {
  count = var.FLAG_DEPLOY >= 1 ? 1 : 0
  depends_on = [random_id.trigger]
  program = [
      "python3",
      "${path.module}/script/validate.py"
  ]
  query = { trigger = random_id.trigger[0].hex }
}

