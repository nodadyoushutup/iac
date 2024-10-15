#!/bin/sh

echo "####################################################"
echo "Spacelift runner Ansible installation script starting"

echo "Creating Python virtual environment"
python3 -m venv venv

echo "Activating Python virtual environment"
source venv/bin/activate

echo "Installing PIP"
python3 -m ensurepip --upgrade

echo "Installing Ansible"
pip install ansible

echo "Setting private key permissions"
export ANSIBLE_PRIVATE_KEY_FILE=$(awk -F ' *=*' '/^private_key_file/ {print $2}' "$ANSIBLE_CONFIG" | tr -d '\r')
chmod 600 $ANSIBLE_PRIVATE_KEY_FILE
echo "####################################################"