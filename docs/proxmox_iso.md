To upload an ISO to Proxmox using SSH, you can use the scp command to transfer the ISO file directly to the Proxmox server's designated ISO storage directory, typically located at /var/lib/pve/storage/local/iso. 
Steps:
Access your Proxmox server via SSH:
Open a terminal window and connect to your Proxmox server using the SSH command:
Code

     ssh root@your_proxmox_server_ip
Navigate to the ISO storage directory:
Use the cd command to change directory to the ISO storage location:
Code

     cd /var/lib/pve/storage/local/iso
Upload the ISO file using SCP:
Execute the scp command to transfer the ISO file from your local machine to the Proxmox server:
Code

     scp /path/to/your/iso.iso root@your_proxmox_server_ip:/var/lib/pve/storage/local/iso
Replace /path/to/your/iso.iso with the actual path to the ISO file on your local machine.
Important Considerations:
Permissions:
Ensure you have the necessary permissions to upload files to the ISO storage directory. If you encounter permission issues, you may need to use sudo or adjust file ownership.
Large ISO files:
For very large ISO files, consider using a file transfer method like rsync for better performance and error handling.