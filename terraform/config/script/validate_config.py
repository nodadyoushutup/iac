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
                first_line == "-----BEGIN OPENSSH PRIVATE KEY-----" 
                and last_line == "-----END OPENSSH PRIVATE KEY-----"
            ):
                return True
    return False

if __name__ == "__main__":
    # Validate private key and set results
    validation_results = {
        "private_key": "true" if validate_private_key(PRIVATE_KEY) else "Private key is not valid"
    }
    
    # Determine overall validity
    valid = all(value == "true" for value in validation_results.values())
    
    # Flatten result, moving validation results to top-level
    result = {
        "valid": "true" if valid else "false",
        **validation_results
    }
    
    # Output result as JSON
    print(json.dumps(result))
