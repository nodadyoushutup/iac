#cloud-config
groups:
    - docker: [${machine}]
users:
    - default
    - name: ${machine}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
runcmd:
    %{ for username in github } 
    - su - ${machine} -c "ssh-import-id gh:${username}" 
    %{ endfor ~}
    - echo "done" > /tmp/cloud-config.done