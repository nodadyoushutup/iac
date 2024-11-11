#!/usr/bin/env python3
import json
import os
import base64


PRIVATE_KEY = os.environ.get("TF_VAR_PRIVATE_KEY")
CONFIG_PATH = os.environ.get("TF_VAR_CONFIG_PATH")

def parse_yaml(yaml_str):
    lines = yaml_str.strip().splitlines()
    result = {}
    stack = [result]
    for line in lines:
        if not line.strip() or line.strip().startswith('#'):
            continue  # Skip empty lines and comments
        indent = len(line) - len(line.lstrip())
        level = indent // 2
        key, sep, value = line.strip().partition(':')
        if not sep:
            return f"Invalid YAML format on line: {line}"
        value = value.strip()
        if not value:
            value = {}
        elif value.isdigit():
            value = int(value)
        elif value.lower() == "true":
            value = True
        elif value.lower() == "false":
            value = False
        elif value.replace('.', '', 1).isdigit():
            value = float(value)
        while len(stack) > level + 1:
            stack.pop()
        current = stack[-1]
        if isinstance(current, dict):
            current[key] = value
        if isinstance(value, dict):
            stack.append(value)
    return result

def load_yaml_file(path):
    if path and os.path.isfile(path):
        with open(path, 'r') as file:
            yaml_content = file.read()
        # return parse_yaml(yaml_content)
        return "YAML file found"
    return "YAML file not found at provided path"

def validate_private_key(path):
    if path and os.path.isfile(path):
        with open(path, "r") as f:
            lines = f.readlines()
        if len(lines) == 1:
            return "Private key must be updated from default"
        if len(lines) >= 2:
            first_line = lines[0].strip()
            last_line = lines[-1].strip()
            if not (
                first_line == "-----BEGIN OPENSSH PRIVATE KEY-----" 
                and last_line == "-----END OPENSSH PRIVATE KEY-----"
            ):
                return "Private key first and last lines are not valid"
            key_body = ''.join(line.strip() for line in lines[1:-1])
            try:
                base64.b64decode(key_body, validate=True)
            except (ValueError, base64.binascii.Error):
                return "Private key body is not valid"
    else:
        return "Private key not found at path provided"
    return "true"

if __name__ == "__main__":
    validation_results = {
        "yaml": load_yaml_file(CONFIG_PATH),
        "private_key": validate_private_key(PRIVATE_KEY)
    }
    valid = all(value == "true" for value in validation_results.values())
    result = {
        "valid": "true" if valid else "false",
        **validation_results
    }
    print(json.dumps(result))
