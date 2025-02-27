#!/usr/bin/env python3
import sys
import json

def sanitize(data, sensitive_keys, sensitive_strings):
    # Add default keys
    sensitive_keys += ["username", "password", "email", "api_key", "apikey", "key", "secret", "secret_key", "access_key"]

    # Convert sensitive keys to lowercase for case-insensitive matching.
    lower_sensitive_keys = [key.lower() for key in sensitive_keys]
    
    if isinstance(data, dict):
        sanitized_dict = {}
        for k, v in data.items():
            # If any sensitive key substring appears in this key, replace its value.
            if any(sensitive in k.lower() for sensitive in lower_sensitive_keys):
                sanitized_dict[k] = "*******"
            else:
                sanitized_dict[k] = sanitize(v, sensitive_keys, sensitive_strings)
        return sanitized_dict
    elif isinstance(data, list):
        return [sanitize(item, sensitive_keys, sensitive_strings) for item in data]
    elif isinstance(data, str):
        # For string values, replace each occurrence of every sensitive string.
        for s in sensitive_strings:
            data = data.replace(s, "*******")
        return data
    else:
        return data

def main():
    # Load the input JSON from stdin.
    input_data = json.load(sys.stdin)
    config_str = input_data.get("config")

    # Convert the JSON-encoded string into a dictionary.
    config = json.loads(config_str)

    # Extract sensitive criteria from the config.
    secret = config.get("jenkins", {}).get("secret", {})
    sensitive_keys = secret.get("key", [])
    sensitive_strings = secret.get("string", [])

    # Sanitize the entire configuration.
    sanitized = sanitize(config, sensitive_keys, sensitive_strings)
    result = {'data': sanitized}

    import logging
    logging.error("RESULT")
    logging.error(result)

    # Output the sanitized config.
    # print(json.dumps({"data": json.dumps(sanitized)}))
    print(json.dumps(result))

if __name__ == '__main__':
    main()
