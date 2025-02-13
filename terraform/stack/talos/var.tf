variable "cluster_name" {
  description = "A name to provide for the Talos cluster"
  type = string
  default = "talos"
}

variable "cluster_endpoint" {
  description = "The endpoint for the Talos cluster"
  type = string
  default = "https://192.168.1.200:6443"
}