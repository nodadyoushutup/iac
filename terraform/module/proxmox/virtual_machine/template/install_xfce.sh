#!/bin/bash
# install_xfce.sh: Installs the XFCE desktop environment and a deb version of Firefox,
# then configures xrdp to start an XFCE session so that when you log in via Windows RDP,
# you get an XFCE desktop and the web UI uses Firefox (installed via apt, not snap).
# Additionally, it reinstalls xfce4-terminal and sets it as the default terminal emulator.

set -e

LOGFILE="/var/log/install_xfce.log"

echo "[INFO] Starting XFCE and Firefox installation script." | tee -a "$LOGFILE"

# Update package lists
echo "[INFO] Updating package lists..." | tee -a "$LOGFILE"
apt-get update -y | tee -a "$LOGFILE"

# Remove the transitional firefox package (which points to snap)
echo "[INFO] Removing transitional firefox package (if installed)..." | tee -a "$LOGFILE"
apt-get purge -y firefox || echo "[INFO] No firefox package to purge." | tee -a "$LOGFILE"
apt-get autoremove -y | tee -a "$LOGFILE"

# Add the Mozilla Team PPA to get the deb version of Firefox
echo "[INFO] Adding Mozilla Team PPA for Firefox deb packages..." | tee -a "$LOGFILE"
add-apt-repository -y ppa:mozillateam/ppa | tee -a "$LOGFILE"
apt-get update -y | tee -a "$LOGFILE"

# Create a preferences file to pin firefox packages from the Mozilla Team PPA
echo "[INFO] Pinning firefox packages to the Mozilla Team PPA..." | tee -a "$LOGFILE"
cat << 'EOF' > /etc/apt/preferences.d/99mozillateam-firefox
Package: firefox*
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 501
EOF

# Install XFCE and its goodies
echo "[INFO] Installing XFCE desktop environment and related packages..." | tee -a "$LOGFILE"
apt-get install -y xfce4 xfce4-goodies | tee -a "$LOGFILE"

# Install Firefox from the deb package provided by the PPA
echo "[INFO] Installing Firefox browser (deb version)..." | tee -a "$LOGFILE"
apt-get install -y firefox | tee -a "$LOGFILE"

# Set Firefox as the default browser
echo "[INFO] Setting Firefox as the default web browser..." | tee -a "$LOGFILE"
update-alternatives --set x-www-browser /usr/bin/firefox | tee -a "$LOGFILE"
xdg-settings set default-web-browser firefox.desktop | tee -a "$LOGFILE"

# Install xfce4-terminal and set it as the default terminal emulator
echo "[INFO] Installing xfce4-terminal and setting it as the default terminal emulator..." | tee -a "$LOGFILE"
apt-get install -y --reinstall xfce4-terminal | tee -a "$LOGFILE"
update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal | tee -a "$LOGFILE"

# Determine the non-root user (if available) to set up their session
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
    echo "[INFO] Non-root user detected: $SUDO_USER. Configuring their session." | tee -a "$LOGFILE"
else
    USER_HOME="$HOME"
    echo "[INFO] No SUDO_USER variable found. Using current home: $USER_HOME" | tee -a "$LOGFILE"
fi

# Create or update the .xsession file to start XFCE
echo "[INFO] Setting XFCE as the default session in $USER_HOME/.xsession..." | tee -a "$LOGFILE"
echo "xfce4-session" > "$USER_HOME/.xsession"
chown $(id -u "$SUDO_USER" 2>/dev/null || echo "$USER_HOME"):"$(id -g "$SUDO_USER" 2>/dev/null || echo "$USER_HOME")" "$USER_HOME/.xsession"
echo "[INFO] .xsession file created and set to start xfce4-session." | tee -a "$LOGFILE"

# Backup and modify the xrdp startup script
echo "[INFO] Backing up /etc/xrdp/startwm.sh to /etc/xrdp/startwm.sh.bak..." | tee -a "$LOGFILE"
cp /etc/xrdp/startwm.sh /etc/xrdp/startwm.sh.bak

echo "[INFO] Modifying /etc/xrdp/startwm.sh to start XFCE..." | tee -a "$LOGFILE"
# Remove lines that automatically start another session
sed -i '/^test -x/d' /etc/xrdp/startwm.sh
sed -i '/^exec/d' /etc/xrdp/startwm.sh
# Append command to start XFCE
echo "startxfce4" >> /etc/xrdp/startwm.sh
chmod +x /etc/xrdp/startwm.sh
echo "[INFO] /etc/xrdp/startwm.sh updated successfully." | tee -a "$LOGFILE"

echo "[INFO] XFCE and Firefox installation and configuration completed." | tee -a "$LOGFILE"
echo "[INFO] If xrdp is already running, please restart it using: systemctl restart xrdp" | tee -a "$LOGFILE"
