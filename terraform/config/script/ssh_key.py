#!/usr/bin/env python3
import sys
import json
import os
import logging
import boto3
import botocore

# Configure logging: default level is INFO (use DEBUG for more verbosity)
logging.basicConfig(level=logging.INFO, format='%(asctime)s %(levelname)s: %(message)s')
logger = logging.getLogger(__name__)

def is_private_key(content):
    """Check for common PEM header markers for private keys."""
    private_markers = [
        "-----BEGIN OPENSSH PRIVATE KEY-----",
        "-----BEGIN RSA PRIVATE KEY-----",
        "-----BEGIN DSA PRIVATE KEY-----",
        "-----BEGIN EC PRIVATE KEY-----",
        "-----BEGIN PRIVATE KEY-----",  # Generic PKCS#8 format.
    ]
    return any(marker in content for marker in private_markers)

def is_public_key(content):
    """Check for common PEM header markers or OpenSSH prefixes for public keys."""
    public_markers = [
        "-----BEGIN PUBLIC KEY-----",
    ]
    ssh_public_prefixes = [
        "ssh-rsa",
        "ssh-dss",
        "ssh-ed25519",
        "ecdsa-sha2-nistp256",
        "ecdsa-sha2-nistp384",
        "ecdsa-sha2-nistp521",
    ]
    return (any(marker in content for marker in public_markers) or
            any(content.strip().startswith(prefix) for prefix in ssh_public_prefixes))

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
    query = read_query()
    logging.debug(f"Configuration query: {query}")
    logging.info("Configuration loaded for bucket: %s", query.get("bucket"))
    
    bucket     = query.get("bucket")
    endpoint   = query.get("endpoints")  # This should be the S3 endpoint URL
    access_key = query.get("access_key")
    secret_key = query.get("secret_key")
    region     = query.get("region")
    # Convert booleans (they come as strings)
    skip_credentials_validation = query.get("skip_credentials_validation", "false").lower() == "true"
    skip_metadata_api_check     = query.get("skip_metadata_api_check", "false").lower() == "true"
    skip_region_validation      = query.get("skip_region_validation", "false").lower() == "true"
    use_path_style              = query.get("use_path_style", "false").lower() == "true"
    skip_requesting_account_id  = query.get("skip_requesting_account_id", "false").lower() == "true"

    logger.info("Using bucket: %s", bucket)
    logger.info("S3 endpoint: %s", endpoint)
    logger.debug("Region: %s", region)

    # Create an S3 client (compatible with services like MinIO).
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

    # List all objects in the specified bucket.
    try:
        response = s3.list_objects_v2(Bucket=bucket)
    except Exception as e:
        logger.error("Error listing objects in bucket %s: %s", bucket, e)
        sys.exit(1)

    keys = []
    if 'Contents' in response:
        keys = [obj['Key'] for obj in response['Contents']]
        logger.info("Found %d objects in bucket.", len(keys))
    else:
        logger.info("No objects found in bucket %s.", bucket)

    # Ensure the ~/.ssh directory exists.
    ssh_dir = os.path.expanduser("~/.ssh")
    if not os.path.exists(ssh_dir):
        logger.info("~/.ssh directory does not exist. Creating it...")
        try:
            os.makedirs(ssh_dir, mode=0o700, exist_ok=True)
        except Exception as e:
            logger.error("Failed to create ~/.ssh directory: %s", e)
            sys.exit(1)
    else:
        logger.debug("~/.ssh directory already exists: %s", ssh_dir)

    # Process each object, downloading both private and public keys.
    for key in keys:
        try:
            logger.debug("Processing object key: %s", key)
            obj = s3.get_object(Bucket=bucket, Key=key)
            content = obj['Body'].read().decode('utf-8')
            base_name = os.path.basename(key)
            name, _ = os.path.splitext(base_name)
            if is_private_key(content):
                # Destination for private key (without extension).
                destination = os.path.join(ssh_dir, name if name else base_name)
                with open(destination, 'w') as f:
                    f.write(content)
                os.chmod(destination, 0o600)
                logger.info("Downloaded private key to %s", destination)
            elif is_public_key(content):
                # Destination for public key (add .pub extension).
                destination = os.path.join(ssh_dir, (name if name else base_name) + ".pub")
                with open(destination, 'w') as f:
                    f.write(content)
                os.chmod(destination, 0o644)
                logger.info("Downloaded public key to %s", destination)
            else:
                logger.debug("Skipping object %s; not recognized as a key.", key)
        except Exception as e:
            logger.error("Error processing key %s: %s", key, e)
            continue

if __name__ == "__main__":
    main()
