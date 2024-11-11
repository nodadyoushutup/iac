#!/usr/bin/env python3
import json
import os
import base64
import yaml


PRIVATE_KEY = os.environ.get("TF_VAR_PRIVATE_KEY")
CONFIG_PATH = os.environ.get("TF_VAR_CONFIG_PATH")

def parse_yaml(yaml_str):
    lines = yaml_str.strip().splitlines()
    result = {}
    stack = [result]
    last_level = 0  # Track the indentation level of the previous line
    
    for line in lines:
        if not line.strip() or line.strip().startswith('#') or line.strip() == "---":
            continue
        
        indent = len(line) - len(line.lstrip())
        level = indent // 2
        
        # Detect inconsistent indentation
        if indent % 2 != 0:
            return f"Inconsistent indentation (not multiple of 2 spaces) on line: {line}"
        if level > last_level + 1:
            return f"Unexpected indentation level on line: {line}"
        
        last_level = level
        
        # Check if line is a list item
        is_list_item = line.lstrip().startswith('-')
        
        # Process the line content
        if is_list_item:
            key = None  # List items don’t have a key
            value = line.lstrip()[1:].strip()  # Remove the dash and any extra space
            if value.isdigit():
                value = int(value)
            elif value.lower() == "true":
                value = True
            elif value.lower() == "false":
                value = False
            elif value.replace('.', '', 1).isdigit():
                value = float(value)
            elif not value:
                value = {}
        else:
            key, sep, value = line.strip().partition(':')
            if not sep:
                return f"Invalid YAML format on line: {line}"
            value = value.strip()
            
            # Check for inline list format
            if value.startswith('[') and value.endswith(']'):
                value = [
                    item.strip() for item in value[1:-1].split(',')
                ]
                # Convert list items to int, float, or bool if possible
                value = [
                    int(v) if v.isdigit() else
                    float(v) if v.replace('.', '', 1).isdigit() else
                    True if v.lower() == "true" else
                    False if v.lower() == "false" else v
                    for v in value
                ]
            elif not value:
                value = {}
            elif value.isdigit():
                value = int(value)
            elif value.lower() == "true":
                value = True
            elif value.lower() == "false":
                value = False
            elif value.replace('.', '', 1).isdigit():
                value = float(value)
        
        # Adjust the stack based on the current level
        while len(stack) > level + 1:
            stack.pop()
        current = stack[-1]
        
        # Append to list if it's a list item
        if is_list_item:
            if isinstance(current, dict):
                # Initialize list if the current dict does not have a list yet
                last_key = list(current.keys())[-1] if current else None
                if last_key is None or not isinstance(current[last_key], list):
                    current[last_key] = []
                current[last_key].append(value)
            elif isinstance(current, list):
                current.append(value)
        else:
            if isinstance(current, dict):
                current[key] = value
            if isinstance(value, dict):
                stack.append(value)
    
    return result

def validate_config_path(path):
    if not path or not os.path.isfile(path):
        return "No file detected at path provided"
    return "true"

def validate_yaml(path):
    if not path or not os.path.isfile(path):
        return "No file detected at path provided"
    with open(path, 'r') as file:
        yaml_content = file.read()
    parsed_yaml = parse_yaml(yaml_content)
    if not isinstance(parsed_yaml, dict):
        return "YAML format is not valid"
    return "true"

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
        "config_path": validate_config_path(CONFIG_PATH),
        "yaml": validate_yaml(CONFIG_PATH),
        "private_key": validate_private_key(PRIVATE_KEY)
    }
    valid = all(value == "true" for value in validation_results.values())
    result = {
        "valid": "true" if valid else "false",
        **{key: str(value) for key, value in validation_results.items()}
    }
    print(json.dumps(result))
