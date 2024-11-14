import subprocess
import os
import sys


# SPACECTL_PATH = f"{os.environ.get('PWD')}/bin/spacectl"
SPACECTL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../bin/spacectl")
MODULES = [
    "terraform-spacelift-stack"
]
SPACELIFT_RUN_ID = os.environ.get("TF_VAR_spacelift_run_id")


def verify_spacectl_path():
    if not os.path.isfile(SPACECTL_PATH):
        print(f"[{SPACELIFT_RUN_ID}] spacectl not found at {SPACECTL_PATH}.")
        sys.exit(1)
    if not os.access(SPACECTL_PATH, os.X_OK):
        print(f"[{SPACELIFT_RUN_ID}] spacectl at {SPACECTL_PATH} is not executable.")
        sys.exit(1)

def create_module_version(module):
    try:
        result = subprocess.run(
            [SPACECTL_PATH, "module", "create-version", "--id", module],
            check=True,
            capture_output=True,
            text=True
        )
        print(f"[{SPACELIFT_RUN_ID}] Version created successfully for module {module}.")
    except subprocess.CalledProcessError as e:
        error_message = e.stderr.strip()
        if "already exists" in error_message:
            print(f"[{SPACELIFT_RUN_ID}] Version for module '{module}' already exists - Skipping.")
        else:
            print(f"[{SPACELIFT_RUN_ID}] Error encountered while creating version for module {module}. Ignoring and continuing.")
            print(f"[{SPACELIFT_RUN_ID}] Detailed error: {error_message}")

if __name__ == "__main__":
    verify_spacectl_path()
    for module in MODULES:
        create_module_version(module)
