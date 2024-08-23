# modules/fortigate/port_forward/main.tf

module "vip" {
  source  = "spacelift.io/nodadyoushutup/vip/fortigate"
  # version = "1.0.0"
  mappedport = var.mappedport
  fosid = var.extport
  name = var.name
  extport = var.extport
  mappedip = {
    range = var.mappedip.range
  }
}

module "policy" {
  source  = "spacelift.io/nodadyoushutup/policy/fortigate"
  # version = "1.0.0"
  name               = var.name
  policyid           = var.extport
  dstaddr = {
    name = var.dstaddr.name
  }
}
