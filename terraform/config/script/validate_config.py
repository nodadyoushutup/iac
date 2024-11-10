#!/usr/bin/env python3
import json
import os

def main():
    # Get the private key path from the first argument
    private_key_path = os.environ.get("TF_VAR_PRIVATE_KEY")
    private_key_valid = False

    # Check if the file exists
    if os.path.isfile(private_key_path):
        # Read the first and last lines of the file
        with open(private_key_path, "r") as f:
            first_line = f.readline().strip()
            last_line = f.readlines()[-1].strip()
        
        # Set file permissions
        os.chmod(private_key_path, 0o600)

        # Check if the first and last lines match the expected format
        if first_line == "-----BEGIN OPENSSH PRIVATE KEY-----" and last_line == "-----END OPENSSH PRIVATE KEY-----":
            private_key_valid = True

    # Output JSON result
    result = {"valid": "true" if private_key_valid else "false"}
    print(json.dumps(result))

if __name__ == "__main__":
    main()
