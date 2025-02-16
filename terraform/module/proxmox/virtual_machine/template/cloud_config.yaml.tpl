#cloud-config
groups:
    - docker: [${machine}]
users:
    - default
    - name: ${machine}
        groups: sudo
        shell: /bin/bash
        sudo: ALL=(ALL) NOPASSWD:ALL
        ssh-import-id: gh:${ssh_import_id}
runcmd:
    # - ${ssh_import}
    - echo "done" > /tmp/cloud-config.done