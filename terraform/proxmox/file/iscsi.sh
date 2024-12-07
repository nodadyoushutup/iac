#!/bin/bash -eu

if [ $# -ne 3 ]; then
    echo "Usage: $0 <ISCSI_SERVER> <MOUNT_POINT> <TARGET>"
    exit 1
fi

# Variables
ISCSI_SERVER="$1"
MOUNT_POINT="$2"
TARGET="$3"
DEVICE=""

# Create mount point
mkdir -p $MOUNT_POINT

# Discover the IQN
echo "Discovering iSCSI targets on $ISCSI_SERVER..."
IQN=$(sudo iscsiadm -m discovery -t sendtargets -p "$ISCSI_SERVER" | grep "$ISCSI_SERVER" | grep "$TARGET" | awk '{print $2}')

if [ -z "$IQN" ]; then
    echo "Error: No IQN found for the iSCSI target."
    exit 1
fi

echo "Discovered IQN: $IQN"

# Check if already logged in
echo "Checking if iSCSI session is already logged in..."
SESSION_LOGGED_IN=$(sudo iscsiadm -m session | grep "$IQN" || true)

if [ -n "$SESSION_LOGGED_IN" ]; then
    echo "iSCSI session for $IQN is already logged in."
else
    # Log in to the iSCSI target
    echo "Logging in to the iSCSI target..."
    sudo iscsiadm -m node --targetname "$IQN" --portal "$ISCSI_SERVER" --login
    if [ $? -ne 0 ]; then
        echo "Error: Failed to log in to the iSCSI target."
        exit 1
    fi
fi

# Wait for the disk to appear
echo "Waiting for the iSCSI disk to appear..."
sleep 5

# Identify the new disk
echo "Identifying the new disk..."
DEVICE=$(lsblk -dpno NAME,TYPE | grep disk | awk '{print $1}' | tail -n 1)

if [ -z "$DEVICE" ]; then
    echo "Error: No new disk found."
    exit 1
fi

echo "New disk identified: $DEVICE"

# Check if the disk is already mounted
if mountpoint -q "$MOUNT_POINT"; then
    echo "The mount point $MOUNT_POINT is already mounted."
    exit 0
fi

# Check if the disk has a valid filesystem
echo "Checking if the disk has a valid filesystem..."
if ! blkid "$DEVICE"; then
    echo "No filesystem detected. Creating a new ext4 filesystem on $DEVICE..."
    sudo mkfs.ext4 "$DEVICE"
else
    echo "A valid filesystem already exists on $DEVICE."
fi

# Mount the disk
echo "Mounting $DEVICE to $MOUNT_POINT..."
sudo mkdir -p "$MOUNT_POINT"
if sudo mount "$DEVICE" "$MOUNT_POINT"; then
    echo "Disk successfully mounted to $MOUNT_POINT."
else
    echo "Error: Failed to mount $DEVICE."
    exit 1
fi

# Add the mount to /etc/fstab
echo "Adding $DEVICE to /etc/fstab for persistence..."
UUID=$(sudo blkid -s UUID -o value "$DEVICE")
if [ -n "$UUID" ]; then
    FSTAB_ENTRY="UUID=$UUID $MOUNT_POINT ext4 defaults,_netdev 0 0"
    if ! grep -q "$UUID" /etc/fstab; then
        echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab
        echo "Fstab entry added: $FSTAB_ENTRY"
    else
        echo "Fstab entry for $DEVICE already exists."
    fi
else
    echo "Error: Could not determine UUID for $DEVICE. Not adding to fstab."
    exit 1
fi
