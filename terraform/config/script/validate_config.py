#!/usr/bin/env python3
import json
import os


def validate_private_key():
    private_key_path = os.environ.get("TF_VAR_PRIVATE_KEY")
    private_key_valid = False

    # Check if the file exists
    if private_key_path and os.path.isfile(private_key_path):
        # Read the lines of the file
        with open(private_key_path, "r") as f:
            lines = f.readlines()
        
        # Ensure the file has enough lines to check
        if len(lines) >= 2:
            first_line = lines[0].strip()
            last_line = lines[-1].strip()
            
            # Set file permissions
            # os.chmod(private_key_path, 0o600)

            # Check if the first and last lines match the expected format
            if first_line == "-----BEGIN OPENSSH PRIVATE KEY-----" and last_line == "-----END OPENSSH PRIVATE KEY-----":
                return True
    return False

if __name__ == "__main__":
    # Get the private key path from the environment variable
    private_key_path = os.environ.get("TF_VAR_PRIVATE_KEY")
    private_key_valid = False

    # Check if the file exists
    if private_key_path and os.path.isfile(private_key_path):
        # Read the lines of the file
        with open(private_key_path, "r") as f:
            lines = f.readlines()
        
        # Ensure the file has enough lines to check
        if len(lines) >= 2:
            first_line = lines[0].strip()
            last_line = lines[-1].strip()
            
            # Set file permissions
            os.chmod(private_key_path, 0o600)

            # Check if the first and last lines match the expected format
            if first_line == "-----BEGIN OPENSSH PRIVATE KEY-----" and last_line == "-----END OPENSSH PRIVATE KEY-----":
                private_key_valid = True

    # Output JSON result
    result = {"valid": "true" if private_key_valid else "false"}
    print(json.dumps(result))
