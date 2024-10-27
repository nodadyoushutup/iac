resource "null_resource" "run_private_key_validation" {
  provisioner "local-exec" {
    command = "${path.module}/validate.sh ${local.config.spacelift.private_key}"
  }

  triggers = {
    run = random_id.trigger.hex
  }
}

output "script_ran" {
  value = "Script has been executed without JSON output."
}
