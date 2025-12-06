#!/bin/bash

NEW_PORT=$1

if [ -z "$NEW_PORT" ]; then
    echo "Usage: $0 <new_port>"
    exit 1
fi

SSHD_CONFIG="/etc/ssh/sshd_config"

# Replace existing Port directive or add if missing
sed -i "s/^#Port .*/Port $NEW_PORT/; s/^Port .*/Port $NEW_PORT/" $SSHD_CONFIG

# If no Port line exists at all, add it
if ! grep -q "^Port $NEW_PORT" $SSHD_CONFIG; then
    echo "Port $NEW_PORT" >> $SSHD_CONFIG
fi

# Restart SSH
systemctl restart sshd 2>/dev/null || systemctl restart ssh
