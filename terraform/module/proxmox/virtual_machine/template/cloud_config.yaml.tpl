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
    %{ if github }
    - su - ${machine} -c "ssh-import-id gh:${github}"
    %{ endif }
    - echo "done" > /tmp/cloud-config.done