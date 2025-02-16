version: 1
config:
   - type: physical
     name: eth0
     mac_address: "52:54:00:12:34:00"
     subnets:
        - type: static
          address: 192.168.1.240
          netmask: 255.255.255.0
          gateway: 192.168.1.1