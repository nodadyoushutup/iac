#cloud-config
version: 2
ethernets:
    ens18:
        %{ if address != "dhcp"}
        dhcp4: no
        addresses: [${address}/24]
        %{ if gateway != null}
        gateway4: ${gateway}
        %{ endif }
        %{ else }
        dhcp4: true
        %{ endif }
        nameservers: 
            addresses: [8.8.8.8, 8.8.4.4]
