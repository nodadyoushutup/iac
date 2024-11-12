import subprocess
import os
import sys
from datetime import datetime

SPACECTL_PATH = "/mnt/workspace/source/terraform/config/bin/spacectl"

def get_timestamp():
    return datetime.now().strftime("%Y/%m/%d %H:%M:%S")

def verify_spacectl_path():
    # Check if spacectl exists and is executable
    if not os.path.isfile(SPACECTL_PATH):
        print(f"{get_timestamp()} Error: spacectl not found at {SPACECTL_PATH}.")
        sys.exit(1)
    if not os.access(SPACECTL_PATH, os.X_OK):
        print(f"{get_timestamp()} Error: spacectl at {SPACECTL_PATH} is not executable.")
        sys.exit(1)

def create_module_version(module):
    try:
        # Run the spacectl command
        subprocess.run(
            [SPACECTL_PATH, "module", "create-version", "--id", module],
            check=True
        )
        print(f"{get_timestamp()} Version created successfully for module {module}.")
    except subprocess.CalledProcessError:
        # If the command fails, handle the error
        print(f"{get_timestamp()} Error encountered while creating version for module {module}. Ignoring and continuing.")

if __name__ == "__main__":
    # Verify spacectl path and permissions
    verify_spacectl_path()
    
    # Define a list of modules
    modules = ["terraform-spacelift-stack"]
    
    # Loop through each module and attempt to create a version
    for module in modules:
        create_module_version(module)
