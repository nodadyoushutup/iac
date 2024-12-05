# data "spacelift_stack" "spacelift_config" {
#   stack_id = "spacelift_config"
# }

# resource "random_id" "trigger" {
#   count = var.FLAG_DEPLOY >= 1 ? 1 : 0
#   byte_length = 8
# }

# data "external" "validate" {
#   count = var.FLAG_DEPLOY >= 1 ? 1 : 0
#   depends_on = [random_id.trigger]
#   program = [
#       "python3",
#       "${path.module}/script/validate.py"
#   ]
#   query = { trigger = random_id.trigger[0].hex }
# }

