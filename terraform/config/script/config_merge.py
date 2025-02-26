#!/usr/bin/env python3
import sys
import json
import os
import boto3
import botocore
import yaml  # Requires PyYAML
import logging

# Configure logging based on PYTHON_LOG_LEVEL environment variable (default to INFO)
log_level = os.environ.get("PYTHON_LOG_LEVEL", "INFO").upper()
numeric_level = getattr(logging, log_level, logging.INFO)
logging.basicConfig(level=numeric_level, format='%(asctime)s - %(levelname)s - %(message)s')

# Allowed file extensions 
ALLOWED_EXTENSIONS = {'.json', '.yaml', '.yml'}

def is_config_file(content):
    # A file qualifies as a config file if it contains the marker "iac_config"
    return "iac_config" in content

def deep_merge(dest, src):
    """
    Recursively merge src dictionary into dest.
    Values in src override those in dest.
    """
    for key, value in src.items():
        if key in dest and isinstance(dest[key], dict) and isinstance(value, dict):
            dest[key] = deep_merge(dest[key], value)
        else:
            dest[key] = value
    return dest

def read_query():
    """
    Try to read JSON input from stdin.
    If none is provided (or an error occurs), fall back to environment variables.
    """
    try:
        if not sys.stdin.isatty():
            data = sys.stdin.read().strip()
            if data:
                logging.debug("Read query from stdin.")
                return json.loads(data)
    except Exception as e:
        logging.debug(f"Failed to read from stdin: {e}")
    logging.debug("Using environment variables for query.")
    return {
        "bucket": os.environ.get("MINIO_CONFIG_BUCKET", ""),
        "endpoints": os.environ.get("MINIO_ENDPOINT", ""),
        "access_key": os.environ.get("MINIO_ACCESS_KEY", ""),
        "secret_key": os.environ.get("MINIO_SECRET_KEY", ""),
        "region": os.environ.get("MINIO_REGION", "us-east-1"),
        "skip_credentials_validation": os.environ.get("SKIP_CREDENTIALS_VALIDATION", "false"),
        "skip_metadata_api_check": os.environ.get("SKIP_METADATA_API_CHECK", "false"),
        "skip_region_validation": os.environ.get("SKIP_REGION_VALIDATION", "false"),
        "use_path_style": os.environ.get("USE_PATH_STYLE", "false"),
        "skip_requesting_account_id": os.environ.get("SKIP_REQUESTING_ACCOUNT_ID", "false")
    }

def main():
    # Read configuration from stdin or environment.
    query = read_query()
    logging.debug(f"Configuration query: {query}")
    logging.info("Configuration loaded for bucket: %s", query.get("bucket"))
    
    bucket = query.get("bucket")
    endpoint = query.get("endpoints")  # S3 endpoint URL
    access_key = query.get("access_key")
    secret_key = query.get("secret_key")
    region = query.get("region")
    # Convert booleans (they come as strings)
    skip_credentials_validation = query.get("skip_credentials_validation", "false").lower() == "true"
    skip_metadata_api_check     = query.get("skip_metadata_api_check", "false").lower() == "true"
    skip_region_validation      = query.get("skip_region_validation", "false").lower() == "true"
    use_path_style              = query.get("use_path_style", "false").lower() == "true"
    skip_requesting_account_id  = query.get("skip_requesting_account_id", "false").lower() == "true"
    
    logging.debug("Creating S3 client.")
    s3 = boto3.client(
        's3',
        endpoint_url=endpoint,
        aws_access_key_id=access_key,
        aws_secret_access_key=secret_key,
        region_name=region,
        config=botocore.client.Config(
            s3={'addressing_style': 'path'} if use_path_style else {}
        )
    )
    logging.info("S3 client created successfully.")
    
    logging.info("Listing objects in bucket: %s", bucket)
    response = s3.list_objects_v2(Bucket=bucket)
    files = []  # List of tuples: (full_key, content, ext)
    if 'Contents' in response:
        logging.info("Found %d objects in bucket.", len(response['Contents']))
        for obj in response['Contents']:
            key = obj['Key']
            # Skip the master file so we don't process it again
            if os.path.basename(key).lower() == "iac_config.json":
                logging.debug("Skipping master file: %s", key)
                continue
            ext = os.path.splitext(key)[1].lower()
            if ext in ALLOWED_EXTENSIONS:
                try:
                    logging.debug("Getting object: %s", key)
                    s3_obj = s3.get_object(Bucket=bucket, Key=key)
                    content = s3_obj['Body'].read().decode('utf-8')
                    # Only consider files that include "iac_config"
                    if is_config_file(content):
                        logging.info("File %s qualifies as a config file.", key)
                        files.append((key, content, ext))
                    else:
                        logging.debug("File %s does not contain marker 'iac_config'.", key)
                except Exception as e:
                    logging.debug("Failed to process file %s: %s", key, e)
                    continue
    else:
        logging.info("No objects found in bucket.")

    # Sort files alphabetically by their base filename (ignoring any directory structure).
    files.sort(key=lambda x: os.path.basename(x[0]).lower())
    logging.debug("Sorted files for processing.")
    logging.info("Processing %d potential config files.", len(files))
    
    master_config = {}
    for full_key, content, ext in files:
        try:
            logging.debug("Parsing file %s", full_key)
            if ext == ".json":
                parsed = json.loads(content)
            elif ext in [".yaml", ".yml"]:
                parsed = yaml.safe_load(content)
            else:
                parsed = {}
        except Exception as e:
            logging.debug("Error parsing file %s: %s", full_key, e)
            continue  # Skip files that cannot be parsed.
        if isinstance(parsed, dict):
            master_config = deep_merge(master_config, parsed)
            logging.debug("Merged configuration from %s", full_key)
    if master_config:
        logging.info("Merged configuration from %d files.", len(files))
    else:
        logging.info("No valid configuration data found; resulting master configuration is empty.")
    
    # Write the master config to a local file named "iac_config.json"
    local_filename = "iac_config.json"
    master_config_str = json.dumps(master_config, indent=2)
    logging.debug("Writing master configuration to %s.", local_filename)
    with open(local_filename, "w", encoding="utf-8") as f:
        f.write(master_config_str)
    logging.info("Master configuration written to %s.", local_filename)
    
    logging.info("Uploading %s back to bucket %s.", local_filename, bucket)
    with open(local_filename, "rb") as f:
        s3.put_object(
            Bucket=bucket,
            Key=local_filename,
            Body=f.read(),
            ContentType="application/json"
        )
    logging.info("Upload complete.")

if __name__ == "__main__":
    main()
