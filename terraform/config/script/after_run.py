import subprocess

def create_module_version(module):
    try:
        # Run the spacectl command
        subprocess.run(
            ["spacectl", "module", "create-version", "--id", module],
            check=True
        )
        print(f"Version created successfully for module {module}.")
    except subprocess.CalledProcessError:
        # If the command fails, handle the error
        print(f"Error encountered while creating version for module {module}. Ignoring and continuing.")

if __name__ == "__main__":
    # Define a list of modules
    modules = ["terraform-spacelift-stack"]
    
    # Loop through each module and attempt to create a version
    for module in modules:
        create_module_version(module)
