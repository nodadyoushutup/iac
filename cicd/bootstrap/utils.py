# File: project/utils.py
import socket
import time
from urllib.parse import urlparse
import paramiko

def extract_host_port(url_str):
    if "://" not in url_str:
        url_str = "dummy://" + url_str
    parsed = urlparse(url_str)
    host = parsed.hostname
    port = parsed.port if parsed.port is not None else 22
    return host, port

def ping_server(host, port, retries=5, interval=2):
    attempt = 1
    while attempt <= retries:
        try:
            print(f"Ping attempt {attempt} to {host}:{port}...")
            with socket.create_connection((host, port), timeout=5) as s:
                print(f"Successfully connected to {host}:{port}")
                return True
        except Exception as e:
            print(f"Attempt {attempt} failed: {e}")
            attempt += 1
            time.sleep(interval)
    print(f"Failed to connect to {host}:{port} after {retries} attempts.")
    return False

def create_ssh_client(host, port, username, password):
    try:
        print(f"Creating SSH client for {host}:{port} as {username}...")
        client = paramiko.SSHClient()
        client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        client.connect(hostname=host, port=port, username=username, password=password)
        print(f"SSH client connected to {host}:{port}.")
        return client
    except Exception as e:
        print(f"Error connecting via SSH: {e}")
        return None
