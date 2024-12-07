#!/bin/bash -eu

hashed_password=$(mkpasswd --method=SHA-512 --salt=$(openssl rand -base64 6) "$1")

echo "{\"password\": \"$hashed_password\"}"
