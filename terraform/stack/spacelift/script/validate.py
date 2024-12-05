#!/usr/bin/env python3 
import json 
import os 
import yaml
import paramiko
import re
 
PRIVATE_KEY = os.environ.get("TF_VAR_DEFAULT_PRIVATE_KEY") 
CONFIG_PATH = os.environ.get("TF_VAR_CONFIG_PATH") 
 
def validate_config_path(path): 
    if not path or not os.path.isfile(path): 
        return "No file detected at path provided" 
    return "valid" 
 
def validate_yaml(path): 
    if not path or not os.path.isfile(path): 
        return "No file detected at path provided" 
    try: 
        with open(path, 'r') as file: 
            yaml.safe_load(file) 
    except yaml.YAMLError as e: 
        return f"YAML format is not valid: {e}" 
    return "valid" 
 
def validate_private_key(path, password=None):
    try:
        try:
            paramiko.RSAKey.from_private_key_file(path, password=password)
        except paramiko.ssh_exception.SSHException:
            try:
                paramiko.ECDSAKey.from_private_key_file(path, password=password)
            except paramiko.ssh_exception.SSHException:
                try:
                    paramiko.DSSKey.from_private_key_file(path, password=password)
                except paramiko.ssh_exception.SSHException:
                    paramiko.Ed25519Key.from_private_key_file(path, password=password)
        return "valid"
    except Exception as e:
        return e

def validate_public_key(key_path):
    try:
        with open(key_path, "r") as file:
            key_data = file.read().strip()
            key_pattern = re.compile(r"^(ssh-(rsa|dss|ed25519|ecdsa) [A-Za-z0-9+/=]+ ?.*)$")
            return bool(key_pattern.match(key_data))
    except Exception as e:
        return e
 
if __name__ == "__main__": 
    validation_results = { 
        "debug": f"valid",
        "config_path": validate_config_path(CONFIG_PATH), 
        "yaml": validate_yaml(CONFIG_PATH), 
        "private_key": validate_private_key(PRIVATE_KEY),
    } 
    valid = all(value == "valid" for value in validation_results.values()) 
    result = { 
        "valid": "true" if valid else "false", 
        **{key: str(value) for key, value in validation_results.items()} 
    } 
    print(json.dumps(result)) 
