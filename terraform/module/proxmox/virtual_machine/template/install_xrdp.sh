#!/bin/bash
# install_xrdp.sh: Installs and configures xrdp on an Ubuntu CLI-only server with logging.

set -e

LOGFILE="/var/log/install_xrdp.log"

echo "[INFO] Starting xrdp installation script." | tee -a "$LOGFILE"

# Update package lists
echo "[INFO] Updating package lists..." | tee -a "$LOGFILE"
apt-get update -y | tee -a "$LOGFILE"

# Install xrdp
echo "[INFO] Installing xrdp..." | tee -a "$LOGFILE"
apt-get install -y xrdp | tee -a "$LOGFILE"

# Enable xrdp to start on boot
echo "[INFO] Enabling xrdp service to start on boot..." | tee -a "$LOGFILE"
systemctl enable xrdp | tee -a "$LOGFILE"

# Start the xrdp service
echo "[INFO] Starting xrdp service..." | tee -a "$LOGFILE"
systemctl start xrdp | tee -a "$LOGFILE"

# Check xrdp service status
echo "[INFO] Checking xrdp service status..." | tee -a "$LOGFILE"
systemctl status xrdp | tee -a "$LOGFILE"

# Optionally, allow RDP port 3389 through UFW if it is active
echo "[INFO] Checking for active UFW firewall..."
if ufw status | grep -q "active"; then
    echo "[INFO] UFW is active. Allowing port 3389/tcp..." | tee -a "$LOGFILE"
    ufw allow 3389/tcp | tee -a "$LOGFILE"
    echo "[INFO] UFW rule added for port 3389." | tee -a "$LOGFILE"
else
    echo "[INFO] UFW is not active. Skipping firewall configuration." | tee -a "$LOGFILE"
fi

echo "[INFO] xrdp installation and configuration completed successfully." | tee -a "$LOGFILE"
