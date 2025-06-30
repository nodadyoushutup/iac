# File: project/main.py
import random
import coloredlogs, logging
from questions import Questionnaire, Question
from actions import action_ping, download_cloud_image, create_vm_action
from utils import extract_host_port, create_ssh_client

# Configure colored logging (this will also print to console)
logger = logging.getLogger(__name__)
coloredlogs.install(level='DEBUG', logger=logger)

def main():
    # Generate a random default VM ID between 301 and 1000.
    default_vm_id = str(random.randint(301, 1000))
    
    # Define questions for connection, datastore settings, and VM parameters.
    questions_list = [
        # Connection details
        Question(
            key="prox_url",
            prompt="Enter the Proxmox endpoint URL (e.g., 192.168.1.100 or 192.168.1.100:22):",
            default="192.168.1.10",
            action=action_ping
        ),
        Question(
            key="ssh_username",
            prompt="Enter the SSH username:",
            default="root"
        ),
        Question(
            key="ssh_password",
            prompt="Enter the SSH password:",
            default="password"
        ),
        # Storage settings
        Question(
            key="cloud_image_datastore",
            prompt="Enter the datastore ID for Proxmox cloud image storage:",
            default="local"
        ),
        Question(
            key="vm_disk_datastore",
            prompt="Enter the datastore ID for VM disks:",
            default="virtualization"
        ),
        Question(
            key="snippet_datastore",
            prompt="Enter the datastore ID for Proxmox snippet storage:",
            default="local"
        ),
        # Cloud image download details
        Question(
            key="cloud_image_url",
            prompt="Enter the cloud image URL:",
            default="https://github.com/nodadyoushutup/cloud-image/releases/download/0.1.13/cloud-image-x86-64-jammy-0.1.13.img"
        ),
        Question(
            key="download_image",
            prompt="Press Enter to download the cloud image file to Proxmox:",
            default="",
            action=download_cloud_image
        ),
        # VM parameters
        Question(
            key="vm_cpu",
            prompt="Enter the number of CPU cores for the VM:",
            default="2"
        ),
        Question(
            key="vm_ram",
            prompt="Enter the amount of RAM (in MB) for the VM:",
            default="2048"
        ),
        Question(
            key="vm_disk",
            prompt="Enter the disk size for the VM (e.g., 50GB):",
            default="50GB"
        ),
        Question(
            key="vm_username",
            prompt="Enter the VM username:",
            default="nodadyoushutup"
        ),
        Question(
            key="vm_password",
            prompt="Enter the VM password:",
            default="password"
        ),
        Question(
            key="vm_hostname",
            prompt="Enter the VM hostname:",
            default="cicd"
        ),
        Question(
            key="vm_ipv4",
            prompt="Enter the VM IPv4 address:",
            default="192.168.1.225"
        ),
        Question(
            key="vm_gateway",
            prompt="Enter the VM gateway:",
            default="192.168.1.1"
        ),
        Question(
            key="vm_id",
            prompt="Enter the VM ID:",
            default="225"
        ),
        Question(
            key="github_username",
            prompt="Enter the GitHub username for SSH import (leave blank for no import):",
            default="nodadyoushutup"
        ),
        Question(
            key="create_vm",
            prompt="Press Enter to create the virtual machine:",
            default="",
            action=create_vm_action
        )
    ]
    
    # Process the questionnaire
    questionnaire = Questionnaire(questions_list)
    questionnaire.ask_all()
    questionnaire.validate_all()
    
    responses = {q.key: q.answer for q in questionnaire.questions}
    
    host, port = extract_host_port(responses["prox_url"])
    print("Attempting to create SSH connection to", host + ":" + str(port), "as user", responses["ssh_username"])
    ssh_client = create_ssh_client(host, port, responses["ssh_username"], responses["ssh_password"])
    if ssh_client is None:
        print("SSH connection failed. Exiting.")
        return
    else:
        print("SSH connection established.")
    
    context = {"ssh_client": ssh_client, "responses": responses}
    
    print("Processing actions...")
    for question in questionnaire.questions:
        if question.action:
            print("Running action for", question.key, "...")
            question.action(context, question.answer)
    
    ssh_client.close()
    print("SSH connection closed.")

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        print("Graceful shutdown. Exiting.")
