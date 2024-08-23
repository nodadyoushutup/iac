# modules/fortigate/port_forward/variable.tf

variable "mappedport" {
  description = "Port number on the internal network that the service is running on"
  type        = number
}

variable "name" {
  description = "Name of the VIP and the Firewall policy"
  type        = string
}

variable "extport" {
  description = "External port number to be used for accessing the service"
  type        = number
}

variable "mappedip" {
  description = "Mapped IP address range for the VIP"
  type        = object({
    range = string
  })
}

variable "dstaddr" {
  description = "Destination address name for the firewall policy"
  type        = object({
    name = string
  })
}
