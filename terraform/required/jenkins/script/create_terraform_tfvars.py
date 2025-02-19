#!/usr/bin/env python3
import argparse
import json
import os
import sys

def to_hcl(obj, indent=0):
    """
    Recursively converts a Python object into an HCL-like formatted string.
    """
    space = " " * indent
    if isinstance(obj, dict):
        lines = ["{"]
        for k, v in obj.items():
            # No quotes for keys in HCL style.
            lines.append(f"{space}  {k} = {to_hcl(v, indent + 2)}")
        lines.append(f"{space}}}")
        return "\n".join(lines)
    elif isinstance(obj, list):
        if not obj:
            return "[]"
        lines = ["["]
        for item in obj:
            lines.append(f"{space}  {to_hcl(item, indent + 2)},")
        lines.append(f"{space}]")
        return "\n".join(lines)
    elif isinstance(obj, str):
        # Ensure proper quoting.
        return f"\"{obj}\""
    elif isinstance(obj, bool):
        return "true" if obj else "false"
    elif isinstance(obj, (int, float)):
        return str(obj)
    elif obj is None:
        # Terraform doesn't have a 'null' literal so we output an empty string.
        return "\"\""
    else:
        raise ValueError(f"Unsupported type: {type(obj)}")

def main():
    parser = argparse.ArgumentParser(
        description="Extract the 'terraform' block from a JSON config and convert it to terraform.tfvars."
    )
    parser.add_argument("json_file", help="Path to the JSON config file")
    parser.add_argument(
        "destination",
        nargs="?",
        default=".",
        help="Destination directory or file path for terraform.tfvars (default: current directory)",
    )
    args = parser.parse_args()

    # Load the JSON file
    try:
        with open(args.json_file, "r") as f:
            config = json.load(f)
    except Exception as e:
        print(f"Error reading JSON file: {e}")
        sys.exit(1)

    # Check that the 'terraform' block exists
    if "terraform" not in config:
        print("Error: JSON does not contain a 'terraform' key.")
        sys.exit(1)

    terraform_data = config["terraform"]

    # Build HCL content by iterating over the top-level keys of the terraform block.
    hcl_lines = []
    for key, value in terraform_data.items():
        hcl_value = to_hcl(value, indent=0)
        hcl_lines.append(f"{key} = {hcl_value}")
    hcl_content = "\n\n".join(hcl_lines)

    # Determine the output path.
    destination = args.destination
    if os.path.isdir(destination):
        output_path = os.path.join(destination, "terraform.tfvars")
    else:
        # If destination is not a directory, assume it's a file path.
        output_path = destination

    # Write the tfvars file.
    try:
        with open(output_path, "w") as f:
            f.write(hcl_content)
        print(f"terraform.tfvars written to {output_path}")
    except Exception as e:
        print(f"Error writing tfvars file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
