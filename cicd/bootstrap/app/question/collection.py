from app.question.base import Question
from app.question.proxmox import (
    QuestionProxmoxEndpoint
)

question_proxmox_endpoint = QuestionProxmoxEndpoint(
    id="proxmox_endpoint",
    text="Proxmox endpoint",
    default="192.168.1.10",
    help="The IP address of your Proxmox server. A raw IP that is used for an SSH connection to puppet Proxmox. (ex: 192.168.1.10)"
)

question_proxmox_username = Question(
    id="proxmox_username",
    text="Proxmox username",
    default="root",
    help="The SSH username for Proxmox. (ex: root)"
)

question_proxmox_password = Question(
    id="proxmox_password",
    text="Proxmox password",
    default=None,
    sensitive=True,
    help="The SSH password for Proxmox. (required)"
)

question_cloud_config_hostname= Question(
    id="cloud_config_hostname",
    text="Virtual machine hostname",
    default="cicd",
    help="The hostname of the CICD virtual machine to be created. (ex: cicd)"
)

question_cloud_config_username= Question(
    id="cloud_config_username",
    text="Virtual machine username",
    default="nodadyoushutup",
    help="The username of the CICD virtual machine to be created. (ex: nodadyoushutup)"
)

question_cloud_config_github= Question(
    id="cloud_config_github",
    text="Virtual machine github",
    default="null",
    help="The Github username to import public SSH keys from. If left null, it no automatic public SSH key import will occur. (ex: nodadyoushutup)"
)

print("### STAGE 1: Proxmox ###")
question_proxmox_endpoint.set_data()
question_proxmox_username.set_data()
question_proxmox_password.set_data()

print("\n")

print("### STAGE 2: Cloud Config ###")
question_cloud_config_hostname.set_data()
question_cloud_config_username.set_data()
question_cloud_config_github.set_data()

print("\n")
