#!/usr/bin/env python3
import json
import os

PRIVATE_KEY = os.environ.get("TF_VAR_PRIVATE_KEY")
CONFIG_PATH = os.environ.get("TF_VAR_CONFIG_PATH")

def validate_private_key(path):
    if path and os.path.isfile(path):
        with open(path, "r") as f:
            lines = f.readlines()
        if len(lines) >= 2:
            first_line = lines[0].strip()
            last_line = lines[-1].strip()
            if (
                first_line == "-----BEGIN OPENSSH PRIVATE KEY2-----" 
                and last_line == "-----END OPENSSH PRIVATE KEY-----"
            ):
                return True
    return False

if __name__ == "__main__":

    validation_results = {
        "private_key": "true" if validate_private_key(PRIVATE_KEY) else "Private key is not valid"
    }
    
    # Determine overall validity
    valid = all(value == "true" for value in validation_results.values())
    
    # Create result dictionary with all string values
    result = {
        "valid": "true" if valid else "false",
        "details": json.dumps(validation_results)  # Serialize the details dictionary as a JSON string
    }
    
    # Output result as JSON
    print(json.dumps(result))
