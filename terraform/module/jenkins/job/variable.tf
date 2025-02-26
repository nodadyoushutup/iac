variable "config" {
  type = any
}

variable "name" {
  type = string
  default = null
}

variable "folder" {
  type = string
  default = null
}

variable "path" {
  type = object({
    xml = optional(string)
    script = optional(string)
  })
  default = null
}

variable "parameter" {
  type = map(any)
  default = null
}

variable "git_repository" {
  type = object({
    branch = optional(string)
    url = optional(string)
  })
  default = null
}

variable "discard_build" {
  type = object({
    day = optional(number)
    max = optional(number)
  })
  default = null
}
