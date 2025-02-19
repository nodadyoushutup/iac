#!/usr/bin/env python3
import argparse
import json
import os
import sys
import logging

# Configure logging to show debug messages.
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(levelname)s - %(message)s')

def to_hcl(obj, indent=0):
    """
    Recursively converts a Python object into an HCL-like formatted string.
    """
    space = " " * indent
    if isinstance(obj, dict):
        lines = ["{"]
        for k, v in obj.items():
            logging.debug("Processing key '%s' at indent level %d", k, indent)
            lines.append(f"{space}  {k} = {to_hcl(v, indent + 2)}")
        lines.append(f"{space}}}")
        return "\n".join(lines)
    elif isinstance(obj, list):
        if not obj:
            logging.debug("Encountered empty list at indent level %d", indent)
            return "[]"
        lines = ["["]
        for item in obj:
            lines.append(f"{space}  {to_hcl(item, indent + 2)},")
        lines.append(f"{space}]")
        return "\n".join(lines)
    elif isinstance(obj, str):
        logging.debug("Processing string: %s", obj)
        return f"\"{obj}\""
    elif isinstance(obj, bool):
        logging.debug("Processing boolean: %s", obj)
        return "true" if obj else "false"
    elif isinstance(obj, (int, float)):
        logging.debug("Processing numeric value: %s", obj)
        return str(obj)
    elif obj is None:
        logging.debug("Processing None value at indent level %d", indent)
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

    logging.debug("Arguments parsed: %s", args)

    # Load the JSON file
    try:
        logging.debug("Attempting to open JSON file: %s", args.json_file)
        with open(args.json_file, "r") as f:
            config = json.load(f)
        logging.debug("JSON file loaded successfully")
    except Exception as e:
        logging.error("Error reading JSON file: %s", e)
        sys.exit(1)

    # Log the top-level keys for debugging
    logging.debug("Top-level keys in JSON: %s", list(config.keys()))

    # Check that the 'terraform' block exists
    if "terraform" not in config:
        logging.error("JSON does not contain a 'terraform' key.")
        sys.exit(1)

    terraform_data = config["terraform"]
    logging.debug("Extracted 'terraform' block: %s", terraform_data)

    # Build HCL content by iterating over the top-level keys of the terraform block.
    hcl_lines = []
    for key, value in terraform_data.items():
        logging.debug("Converting key '%s' to HCL", key)
        hcl_value = to_hcl(value, indent=0)
        hcl_lines.append(f"{key} = {hcl_value}")
    hcl_content = "\n\n".join(hcl_lines)

    # Determine the output path.
    destination = args.destination
    if os.path.isdir(destination):
        output_path = os.path.join(destination, "terraform.tfvars")
        logging.debug("Destination is a directory. Output path set to: %s", output_path)
    else:
        output_path = destination
        logging.debug("Destination is a file. Output path set to: %s", output_path)

    # Write the tfvars file.
    try:
        logging.debug("Attempting to write HCL content to: %s", output_path)
        with open(output_path, "w") as f:
            f.write(hcl_content)
        logging.info("terraform.tfvars written to %s", output_path)
    except Exception as e:
        logging.error("Error writing tfvars file: %s", e)
        sys.exit(1)

if __name__ == "__main__":
    main()
