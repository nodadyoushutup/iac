# resource "spacelift_context_attachment" "config_config" {
#     count = var.ENV_FLAG_PYVENV == 2 ? 1 : 0
#     depends_on = [spacelift_context.config]
#     context_id = spacelift_context.config[count.index].id
#     stack_id   = data.spacelift_stack.config.id
#     priority   = 0
# }