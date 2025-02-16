#cloud-config
groups:
    - docker: ["${username}"]
users:
    - default
    - name: "${username}"
      groups: sudo
      shell: /bin/bash
      sudo: ALL=(ALL) NOPASSWD:ALL
      ssh-authorized-keys: ${ssh_key}
runcmd:
    - ${ssh_import}
    - echo "done" > /tmp/cloud-config.done