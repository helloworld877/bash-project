#!/bin/bash

NEW_PORT=$1

if [ -z "$NEW_PORT" ]; then
    echo "Usage: $0 <new_port>"
    exit 1
fi

SSHD_CONFIG="/etc/ssh/sshd_config"
SSHD_DIR="/etc/ssh/sshd_config.d"

# Remove all existing Port lines everywhere
sed -i '/^Port /d' "$SSHD_CONFIG"
sed -i '/^#Port /d' "$SSHD_CONFIG"

# Remove Port lines in sshd_config.d
for FILE in $SSHD_DIR/*.conf; do
    sed -i '/^Port /d' "$FILE"
    sed -i '/^#Port /d' "$FILE"
done

# Add new port at end of main config
echo "Port $NEW_PORT" >> "$SSHD_CONFIG"

# Restart SSH safely
if systemctl restart sshd 2>/dev/null; then
    echo "SSH restarted successfully."
else
    systemctl restart ssh
fi
