#!/usr/bin/env python3

import json
import os
import yaml
import paramiko
import re
from pathlib import Path


CONFIG_ORIG_PATH = os.environ.get("TF_VAR_CONFIG_PATH_CONFIG")

DEFAULT_PRIVATE_KEY = os.environ.get("TF_VAR_DEFAULT_PRIVATE_KEY")
DEFAULT_PUBLIC_KEY_DIR = os.environ.get("TF_VAR_DEFAULT_PUBLIC_KEY_DIR")
DEFAULT_USERNAME = os.environ.get("TF_VAR_DEFAULT_USERNAME")
DEFAULT_PASSWORD = os.environ.get("TF_VAR_DEFAULT_PASSWORD")

CURRENT_FILE_PATH = os.path.abspath(__file__)
PARENT_DIR = os.path.dirname(os.path.dirname(CURRENT_FILE_PATH))
CONFIG_SUB_PATH = os.path.join(PARENT_DIR, 'config.sub.yaml')


def validate_config_path(path):
    if not path or not os.path.isfile(path):
        return "No file detected at path provided"
    return "valid"


def validate_yaml_syntax(path):
    if not path or not os.path.isfile(path):
        return "No file detected at path provided"
    try:
        with open(path, 'r') as file:
            yaml.safe_load(file)
    except yaml.YAMLError as e:
        return f"YAML format is not valid: {e}"
    return "valid"


def validate_private_key(path, password=None):
    if not path or not os.path.isfile(path):
        return "No file detected at path provided"
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
        return str(e).capitalize()


def validate_public_key(key_path):
    try:
        with open(key_path, "r") as file:
            key_data = file.read().strip()
            key_pattern = re.compile(r"^(ssh-(rsa|dss|ed25519|ecdsa) [A-Za-z0-9+/=]+ ?.*)$")
            return bool(key_pattern.match(key_data))
    except Exception as e:
        return str(e).capitalize()


def validate_public_key_dir(directory):
    if not directory or not os.path.isdir(directory):
        return "No directory detected at path provided"
    public_keys = list(Path(directory).glob("*.pub"))
    if not public_keys:
        return "No public key files (.pub) found in directory"
    results = []
    for key_file in public_keys:
        result = validate_public_key(key_file)
        if not result:
            results.append(f"Invalid public key: {key_file}")
    if results:
        return "; ".join(results)
    return "valid"

def validate_username(username):
    if not username:
        return "Username not set"
    return "valid"


def validate_password(password):
    if not password:
        return "Password not set"
    return "valid"


if __name__ == "__main__":
    validation_results = {
        "debug": f"valid",
        "config_path": validate_config_path(CONFIG_ORIG_PATH),
        "config_yaml_syntax": validate_yaml_syntax(CONFIG_SUB_PATH),
        "default_private_key": validate_private_key(DEFAULT_PRIVATE_KEY),
        "default_public_key_dir": validate_public_key_dir(DEFAULT_PUBLIC_KEY_DIR),
        "default_username": validate_username(DEFAULT_USERNAME),
        "default_password": validate_password(DEFAULT_PASSWORD),
    }
    valid = all(value == "valid" for value in validation_results.values())
    result = {
        "valid": "true" if valid else "false",
        **{key: str(value) for key, value in validation_results.items()}
    }
    print(json.dumps(result))
