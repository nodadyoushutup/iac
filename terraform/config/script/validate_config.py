#!/usr/bin/env python3
import json
import os


PRIVATE_KEY = os.environ.get("TF_VAR_PRIVATE_KEY")
CONFIG_PATH = os.environ.get("TF_VAR_CONFIG_PATH")

def validate_private_key(path):
    private_key_path = path
    if private_key_path and os.path.isfile(private_key_path):
        with open(private_key_path, "r") as f:
            lines = f.readlines()
        if len(lines) >= 2:
            first_line = lines[0].strip()
            last_line = lines[-1].strip()
            if (
                first_line == "-----BEGIN OPENSSH PRIVATE KEY-----" 
                and last_line == "-----END OPENSSH PRIVATE KEY-----"
            ):
                return True
    return False

if __name__ == "__main__":

    validation_results = {
        "private_key": False
    }

    private_key_valid = validate_private_key(PRIVATE_KEY)

    if private_key_valid:
        validation_results["private_key"] = True
    else:
        validation_results["private_key"] = "Private key is not valid"
    
    valid = all(value is True for value in validation_results.values())
    result = {
        "valid": "true" if valid else "false",
        "details": validation_results
    }
    print(json.dumps(result))
