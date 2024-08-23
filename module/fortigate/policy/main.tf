# modules/fortigate/policy/main.tf

resource "fortios_firewall_policy" "policy" {
    action             = var.action
    logtraffic         = var.logtraffic
    name               = var.name
    policyid           = var.policyid
    schedule           = var.schedule
    wanopt             = var.wanopt
    wanopt_detection   = var.wanopt_detection
    wanopt_passive_opt = var.wanopt_passive_opt
    wccp               = var.wccp
    webcache           = var.webcache
    webcache_https     = var.webcache_https
    wsso               = var.wsso
    dstaddr {
        name = var.dstaddr.name
    }
    dstintf {
        name = var.dstintf.name
    }
    service {
        name = var.service.name
    }
    srcaddr {
        name = var.srcaddr.name
    }
    srcintf {
        name = var.srcintf.name
    }
}