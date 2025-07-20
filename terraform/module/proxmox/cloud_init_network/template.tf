locals { # Template
    template = "#cloud-config\n${yamlencode({ network = local.network_computed })}"
}
