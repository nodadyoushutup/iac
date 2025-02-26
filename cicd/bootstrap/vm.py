# File: project/vm.py
import os
import time
from passlib.hash import sha512_crypt  # Cross-platform hashing

def create_virtual_machine(context):
    """
    Creates the virtual machine on the remote Proxmox machine using provided parameters.
    Steps:
      1. Check if VM exists; if so, ask to replace.
      2. Read and format the cloud-config template (no network config).
      3. Upload the snippet.
      4. Create the VM (SeaBIOS).
      5. Import the downloaded .img as an unused disk.
      6. Wait and parse qm config for the unused volume ID.
      7. Attach the disk as scsi0.
      8. Optionally resize the disk.
      9. Set boot order.
      10. Set the cloud config snippet (user portion).
      11. Enable QEMU agent.
      12. (Optionally) set ipconfig0 if user provided vm_ipv4/gateway.
      13. Start the VM.
    """
    ssh_client = context.get("ssh_client")
    responses = context.get("responses", {})
    
    vm_id = responses.get("vm_id")
    vm_cpu = responses.get("vm_cpu")
    vm_ram = responses.get("vm_ram")
    vm_disk = responses.get("vm_disk")  # e.g. "50GB"
    vm_username = responses.get("vm_username")
    vm_password = responses.get("vm_password")
    vm_hostname = responses.get("vm_hostname")
    vm_ipv4 = responses.get("vm_ipv4")       # Now used for ipconfig0
    vm_gateway = responses.get("vm_gateway") # Now used for ipconfig0
    cloud_image_datastore = responses.get("cloud_image_datastore", "local")
    disk_datastore = responses.get("vm_disk_datastore", "virtualization")
    snippet_datastore = responses.get("snippet_datastore", "local")
    github_username = responses.get("github_username")
    
    print("Starting VM creation for VM ID:", vm_id)
    try:
        # STEP 1: Check if VM exists
        print("Step 1: Checking if VM with ID", vm_id, "already exists...")
        check_cmd = f"qm status {vm_id}"
        print("Running command:", check_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(check_cmd, get_pty=True)
        exit_code = stdout.channel.recv_exit_status()
        print("Exit code from qm status:", exit_code)
        if exit_code == 0:
            print("VM with ID", vm_id, "already exists.")
            # For now, auto-remove if it exists
            replace = "y"
            if replace == "y":
                print("Removing existing VM", vm_id, "...")
                remove_cmd = f"qm destroy {vm_id} --purge"
                print("Running command:", remove_cmd)
                stdin, stdout, stderr = ssh_client.exec_command(remove_cmd, get_pty=True)
                stdout.channel.recv_exit_status()
                print("Existing VM", vm_id, "removed.")
            else:
                print("VM creation aborted by user.")
                return
        else:
            print("VM with ID", vm_id, "does not exist. Proceeding with creation.")
        
        # STEP 2: Read cloud-config template (no IP references)
        print("Step 2: Reading local cloud-config template...")
        try:
            template_path = os.path.join(os.path.dirname(__file__), "cicd-cloud-config-template.yaml")
            print("Template path:", template_path)
            with open(template_path, "r") as f:
                template = f.read()
            print("Cloud-config template read successfully.")
        except Exception as e:
            print("Error reading cloud config template:", e)
            return
        
        # STEP 3: Build GitHub SSH import command if needed
        print("Step 3: Building GitHub SSH import command if needed...")
        if github_username:
            github_cmd = f"su - {vm_username} -c 'ssh-import-id gh:{github_username}'"
            print("Will import SSH keys from GitHub user:", github_username)
            print(f"Using command: {github_cmd}")
        else:
            github_cmd = "echo 'No SSH Import'"
            print("No GitHub username provided. Skipping SSH key import.")
            
        
        # STEP 4: Hash the VM password (cloud-init expects a hashed password)
        print("Step 4: Hashing VM password...")
        if vm_password:
            try:
                hashed_pw = sha512_crypt.hash(vm_password)
                print("Password hashed successfully.")
            except Exception as e:
                print("Error hashing password:", e)
                return
        else:
            hashed_pw = ""
        
        # STEP 5: Format the cloud-config snippet
        print("Step 5: Formatting the cloud-config snippet...")
        # Note: We do NOT include IP or gateway references here.
        cloud_config = template.format(
            vm_hostname=vm_hostname,
            vm_username=vm_username,
            vm_password=hashed_pw,
            github_cmd=github_cmd
        )
        print("Cloud-config snippet formatted successfully.")
        
        # STEP 6: Upload the cloud-config snippet to Proxmox
        print("Step 6: Uploading cloud-config snippet to Proxmox...")
        remote_snippet_path = "/var/lib/vz/snippets/cicd-cloud-config.yaml"
        print("Uploading to:", remote_snippet_path)
        try:
            sftp = ssh_client.open_sftp()
            with sftp.file(remote_snippet_path, "w") as remote_file:
                remote_file.write(cloud_config)
            sftp.close()
            print("Cloud config snippet uploaded to", remote_snippet_path)
        except Exception as e:
            print("Error uploading cloud config snippet:", e)
            return
        
        # STEP 7: Create the VM with default BIOS (SeaBIOS)
        print("Step 7: Creating VM with default BIOS (SeaBIOS)...")
        create_cmd = (
            f"qm create {vm_id} "
            f"--name {vm_hostname} "
            f"--cores {vm_cpu} "
            f"--memory {vm_ram} "
            f"--ostype l26 "
        )
        print("Running command:", create_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(create_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        print("VM", vm_id, "created with basic configuration.")
        
        # STEP 8: Import the .img as an unused disk
        print("Step 8: Importing the downloaded .img file as an unused disk...")
        if cloud_image_datastore == "local":
            image_path = "/var/lib/vz/template/iso/cicd-image-amd64.img"
        else:
            image_path = f"/mnt/{cloud_image_datastore}/cicd-image-amd64.img"
        print("Cloud image path:", image_path)
        import_cmd = f"qm importdisk {vm_id} {image_path} {disk_datastore}"
        print("Running command:", import_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(import_cmd, get_pty=True)
        exit_code = stdout.channel.recv_exit_status()
        out = stdout.read().decode()
        err = stderr.read().decode()
        print("Import disk output:", out.strip())
        print("Import disk error:", err.strip())
        print("Disk import exit code:", exit_code)
        if exit_code != 0:
            print("Disk import failed. Aborting VM creation.")
            return
        
        print("Waiting briefly for Proxmox to register the imported disk...")
        time.sleep(2)
        
        # STEP 9: Determine the "unused" volume ID from qm config
        print("Step 9: Checking qm config for newly imported unused volume ID...")
        config_cmd = f"qm config {vm_id}"
        print("Running command:", config_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(config_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        config_out = stdout.read().decode().strip().splitlines()
        print("qm config output:")
        print("\n".join(config_out))
        
        volume_id = None
        for line in config_out:
            if line.startswith("unused"):
                parts = line.split(":", 1)
                if len(parts) == 2:
                    volume_id = parts[1].strip()
                    if "," in volume_id:
                        volume_id = volume_id.split(",")[0]
                    print("Found unused volume:", volume_id)
                    break
        
        if not volume_id:
            print("No unused volume found after import. Aborting VM creation.")
            return
        
        # STEP 10: Attach the unused disk as scsi0
        print("Step 10: Attaching the unused disk as scsi0 (virtio-scsi-single)...")
        set_cmd = (
            f"qm set {vm_id} "
            f"--scsihw virtio-scsi-single "
            f"--scsi0 {disk_datastore}:vm-{vm_id}-disk-0,discard=on,iothread=1,ssd=1 "
            f"--ide2 {disk_datastore}:cloudinit,media=cdrom"
        )
        print("Running command:", set_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(set_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        print("Attached disk volume", volume_id, "as scsi0 and cloud-init on ide2.")
        
        # STEP 11: Optionally resize the disk
        if vm_disk:
            print("Step 11: Resizing the disk to", vm_disk, "...")
            resize_cmd = f"qm resize {vm_id} scsi0 {vm_disk}"
            print("Running command:", resize_cmd)
            stdin, stdout, stderr = ssh_client.exec_command(resize_cmd, get_pty=True)
            stdout.channel.recv_exit_status()
            print("Resized scsi0 disk to", vm_disk)
        
        # STEP 12: Set boot order to scsi0
        print("Step 12: Setting VM boot order to scsi0...")
        boot_cmd = f"qm set {vm_id} --boot order=scsi0"
        print("Running command:", boot_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(boot_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        print("Set VM", vm_id, "to boot from scsi0.")
        
        # STEP 13: Set the cloud config snippet (user portion)
        print("Step 13: Applying the cloud config snippet via cicustom...")
        cicustom_cmd = f"qm set {vm_id} --cicustom user={snippet_datastore}:snippets/cicd-cloud-config.yaml"
        print("Running command:", cicustom_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(cicustom_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        print("Cloud config snippet set for VM", vm_id)
        
        # STEP 14: Enable QEMU agent
        print("Step 14: Enabling QEMU agent on the VM...")
        agent_cmd = f"qm set {vm_id} --agent 1"
        print("Running command:", agent_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(agent_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        print("QEMU agent enabled for VM", vm_id)
        
        # STEP 14.5: If user specified vm_ipv4 + vm_gateway, set ipconfig0
        if vm_ipv4 and vm_gateway:
            print("Step 14.5: Setting static IP config (ipconfig0) in Proxmox...")
            ipconfig_cmd = f"qm set {vm_id} --ipconfig0 ip={vm_ipv4}/24,gw={vm_gateway}"
            print("Running command:", ipconfig_cmd)
            stdin, stdout, stderr = ssh_client.exec_command(ipconfig_cmd, get_pty=True)
            stdout.channel.recv_exit_status()
            print("Static IP config set to", vm_ipv4, "with gateway", vm_gateway)
        
        # STEP 15: Set NIC, e.g. virtio on vmbr0:
        print("Setting VM NIC to virtio on vmbr0...")
        net_cmd = f"qm set {vm_id} --net0 virtio,bridge=vmbr0"
        print("Running command:", net_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(net_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        print("Set VM", vm_id, "NIC to virtio on vmbr0.")
        
        # STEP 16: Start the VM
        print("Step 16: Starting the VM...")
        start_cmd = f"qm start {vm_id}"
        print("Running command:", start_cmd)
        stdin, stdout, stderr = ssh_client.exec_command(start_cmd, get_pty=True)
        stdout.channel.recv_exit_status()
        print("VM", vm_id, "started successfully.")
        
        print("VM creation process completed for VM ID:", vm_id)
    except Exception as e:
        print("Exception in create_virtual_machine:", e)
        return
