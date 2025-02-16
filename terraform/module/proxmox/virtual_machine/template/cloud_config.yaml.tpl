#cloud-config
groups:
    - docker: ["${username}"]
users:
    - default
    - name: "${username}"
      groups: sudo
      shell: /bin/bash
      sudo: ALL=(ALL) NOPASSWD:ALL
      %{ if length(ssh_public_key) > 0 }
      ssh-authorized-keys:
        %{   for key in ssh_public_key }
        - ${key}
        %{   endfor }
      %{ endif }
runcmd:
    - ${ssh_import}
    - echo "done" > /tmp/cloud-config.done