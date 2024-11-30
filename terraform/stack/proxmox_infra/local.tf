locals {
  config = yamldecode(try(file(var.PATH_CONFIG), {}))
}