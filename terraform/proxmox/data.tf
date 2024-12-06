data "local_file" "ssh_public_key" {
  for_each = toset(local.config.data.default.public_key_dir)
  filename = each.value
}

output "ssh_public_key" {
  value = data.local_file.ssh_public_key
}