#!/bin/bash

JAIL_LOG="/home/devcontainers/gatekeeper/jail.log"
PAROLE_TIME="24 hours ago" # Change to "24 hours ago" after testing
# PAROLE_TIME="24 hours ago" # Normal production setting
# PAROLE_TIME="1 minute ago"  # Use for testing only

echo "⚖️ PAROLE BOARD: Checking for expired bans..."

while read -r line; do
    # 1. Grab the timestamp part (everything before the ':')
    BAN_DATE_STR=$(echo "$line" | cut -d':' -f1-3)
    
    # 2. Grab the IP (Looking for the number pattern)
    IP=$(echo "$line" | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')

    # 3. Time calculation
    BAN_SEC=$(date -d "$BAN_DATE_STR" +%s)
    EXPIRY_SEC=$(date -d "$PAROLE_TIME" +%s)

    if [ "$BAN_SEC" -lt "$EXPIRY_SEC" ]; then
        if [ ! -z "$IP" ]; then
            echo "🔓 Parole granted for $IP. Removing from firewall..."
            sudo ufw delete deny from "$IP"
        fi
    else
        echo "🔒 $IP is still serving their sentence."
    fi
done < "$JAIL_LOG"
