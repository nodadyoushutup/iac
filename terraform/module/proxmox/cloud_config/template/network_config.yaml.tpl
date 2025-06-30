#cloud-config
network:
  version: 2
  ethernets:
    eth0:
      match:
        name: e*
      set-name: eth0
      %{ if ipv4.address != "dhcp"}
      dhcp4: no
      addresses: 
      - ${ipv4.address}/24
      %{ if ipv4.gateway != null}
      gateway4: ${ipv4.gateway}
      %{ endif }
      %{ else }
      dhcp4: true
      %{ endif }
      nameservers:
        addresses: 
        - 8.8.8.8
        - 8.8.4.4
