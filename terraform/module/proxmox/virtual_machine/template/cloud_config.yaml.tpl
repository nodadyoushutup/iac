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
    - ${ssh_import}
    - echo "done" > /tmp/cloud-config.done