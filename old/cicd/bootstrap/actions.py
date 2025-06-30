# File: project/actions.py
from vm import create_virtual_machine

def action_ping(context, prox_url):
    ssh_client = context.get("ssh_client")
    if ssh_client is None:
        print("No SSH connection available for ping.")
        return
    print("Running remote ping test...")
    try:
        stdin, stdout, stderr = ssh_client.exec_command("echo 'Remote ping successful'", get_pty=True)
        output = stdout.read().decode().strip()
        error = stderr.read().decode().strip()
        if output:
            print("Remote ping output:", output)
        if error:
            print("Remote ping error:", error)
    except Exception as e:
        print("Error during remote ping:", e)

def download_cloud_image(context, dummy_input):
    ssh_client = context.get("ssh_client")
    responses = context.get("responses", {})
    cloud_image_datastore = responses.get("cloud_image_datastore", "local")
    cloud_image_url = responses.get("cloud_image_url")
    
    if cloud_image_datastore == "local":
        remote_file = "/var/lib/vz/template/iso/cicd-image-amd64.img"
    else:
        remote_file = f"/mnt/{cloud_image_datastore}/cicd-image-amd64.img"
    
    print("Preparing to download cloud image to remote path:", remote_file)
    check_cmd = f"if [ -f {remote_file} ]; then echo 'File exists, removing'; rm -f {remote_file}; else echo 'File does not exist'; fi"
    print("Executing remote file check command:", check_cmd)
    try:
        stdin, stdout, stderr = ssh_client.exec_command(check_cmd, get_pty=True)
        out = stdout.read().decode().strip()
        err = stderr.read().decode().strip()
        print("Remote check output:", out)
        if err:
            print("Remote check error:", err)
    except Exception as e:
        print("Error executing remote file check:", e)
    
    download_cmd = f"wget --progress=bar:force -O {remote_file} {cloud_image_url}"
    print("Executing remote download command:", download_cmd)
    try:
        stdin, stdout, stderr = ssh_client.exec_command(download_cmd, get_pty=True)
        while not stdout.channel.exit_status_ready():
            if stdout.channel.recv_ready():
                output = stdout.channel.recv(1024).decode('utf-8')
                print(output, end="")
            if stderr.channel.recv_stderr_ready():
                err_output = stderr.channel.recv_stderr(1024).decode('utf-8')
                print(err_output, end="")
        output = stdout.read().decode('utf-8')
        err_output = stderr.read().decode('utf-8')
        if output:
            print(output)
        if err_output:
            print(err_output)
        print("Cloud image downloaded successfully on remote machine.")
    except Exception as e:
        print("Error executing remote download:", e)

def create_vm_action(context, dummy_input):
    create_virtual_machine(context)
