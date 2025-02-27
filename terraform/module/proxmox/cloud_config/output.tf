output "name" {
    value = local.name
}

output "node_name" {
    value = local.node_name_computed
}

output "username" {
    value = local.auth_computed.username_computed
}

output "address" {
    value = local.address_computed
}

output "overwrite" {
    value = local.overwrite_computed
}

output "github" {
    value = local.auth_computed.github_computed
}

output "gateway" {
    value = local.gateway_computed
}

output "type" {
    value = local.type
}

output "template" {
    value = local.template
}

output "password" {
    value = data.external.hash_password.result.data
    sensitive = true
}