locals {
  config = try(yamldecode(file(fileexists(var.CONFIG) ? var.CONFIG : null)), {})
}