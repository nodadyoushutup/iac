from app.config import Config
from app.conncection import Connection
from app.cloud_config import CloudConfig

def ask_question():
    from app.question import collection

def connect(type):
    if type == "proxmox":
        conn_info = {
            "endpoint": Config.proxmox_endpoint,
            "username": Config.proxmox_username,
            "password": Config.proxmox_password,
        }
    return Connection(**conn_info)

print("\n\nWelcome to the NoDadYouShutUp CICD Bootstrapper. Please enter configuration values...\n")

ask_question()

conn = connect("proxmox")
cloud_user_cfg = CloudConfig(
    conn,
    hostname=Config.cloud_config_hostname,
    username=Config.cloud_config_username, 
    github=Config.cloud_config_github
)
conn.close()
