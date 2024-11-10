# modules/fortigate/policy/variable.tf

variable "action" {
  type    = string
  default = "accept"
}

variable "logtraffic" {
  type    = string
  default = "all"
}

variable "name" {
  type    = string
}

variable "policyid" {
  type    = number
}

variable "schedule" {
  type    = string
  default = "always"
}

variable "wanopt" {
  type    = string
  default = "disable"
}

variable "wanopt_detection" {
  type    = string
  default = "off"
}

variable "wanopt_passive_opt" {
  type    = string
  default = "default"
}

variable "wccp" {
  type    = string
  default = "disable"
}

variable "webcache" {
  type    = string
  default = "disable"
}

variable "webcache_https" {
  type    = string
  default = "disable"
}

variable "wsso" {
  type    = string
  default = "disable"
}

variable "dstaddr" {
  type    = object({
    name = string
  })
}

variable "dstintf" {
  type    = object({
    name = string
  })
  default = {
    name = "lan"
  }
}

variable "service" {
  type    = object({
    name = string
  })
  default = {
    name = "ALL"
  }
}

variable "srcaddr" {
  type    = object({
    name = string
  })
  default = {
    name = "all"
  }
}

variable "srcintf" {
  type    = object({
    name = string
  })
  default = {
    name = "wan"
  }
}
