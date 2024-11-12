import subprocess
import os
import sys
from datetime import datetime

SPACECTL_PATH = "/mnt/workspace/source/terraform/config/bin/spacectl"

def get_timestamp():
    return datetime.now().strftime("%Y/%m/%d %H:%M:%S")

def verify_spacectl_path():
    if not os.path.isfile(SPACECTL_PATH):
        print(f"{get_timestamp()} Error: spacectl not found at {SPACECTL_PATH}.")
        sys.exit(1)
    if not os.access(SPACECTL_PATH, os.X_OK):
        print(f"{get_timestamp()} Error: spacectl at {SPACECTL_PATH} is not executable.")
        sys.exit(1)

def create_module_version(module):
    try:
        result = subprocess.run(
            [SPACECTL_PATH, "module", "create-version", "--id", module],
            check=True,
            capture_output=True,
            text=True
        )
        print(f"{get_timestamp()} Version created successfully for module {module}.")
    except subprocess.CalledProcessError as e:
        error_message = e.stderr.strip()
        if "already exists" in error_message:
            print(f"{get_timestamp()} Notice: Version for module {module} already exists. Ignoring as intended.")
        else:
            print(f"{get_timestamp()} Error encountered while creating version for module {module}. Ignoring and continuing.")
            print(f"{get_timestamp()} Detailed error: {error_message}")

if __name__ == "__main__":
    verify_spacectl_path()
    try:
        result = subprocess.run(
            [SPACECTL_PATH, "module", "list"],
            check=True,
            capture_output=True,
            text=True
        )
        print(f"{get_timestamp()} {result}")
    except subprocess.CalledProcessError as e:
        print(e)
