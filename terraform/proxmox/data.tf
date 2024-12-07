resource "random_id" "trigger" {
  byte_length = 8
}

data "local_file" "ssh_public_key" {
  for_each = toset(local.public_key)
  filename = each.value
}

data "external" "hash_password" {
  depends_on = [random_id.trigger]
  program = ["sh", "${path.module}/hash_password.sh", local.config.data.default.password]
  query = {
    trigger = random_id.trigger.hex
  }
}

output "ssh_public_key" {
  value = data.local_file.ssh_public_key
}