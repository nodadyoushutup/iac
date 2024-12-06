data "spacelift_stack" "spacelift" {
  stack_id = "spacelift"
}

resource "random_id" "trigger" {
  byte_length = 8
}

data "external" "validate" {
  depends_on = [random_id.trigger]
  program = [
    "python3",
    "${path.module}/script/validate.py"
  ]
  query = {
    trigger = random_id.trigger.hex
  }
}

