#!/bin/bash

# Configuration
LOG_FILE="/var/log/nginx/access.log"
THRESHOLD=10
JAIL_LOG="/home/devcontainers/gatekeeper/jail.log"

echo "🛡️ BOUNCER: Scanning for aggressive offenders..."

# Find IPs with more than $THRESHOLD 404 errors
OFFENDERS=$(awk '$9 == 404 {print $1}' "$LOG_FILE" | sort | uniq -c | awk -v limit="$THRESHOLD" '$1 > limit {print $2}')

if [ -z "$OFFENDERS" ]; then
    echo "✅ No one to ban today. Everyone is behaving."
    exit 0
fi

for IP in $OFFENDERS; do
    # Check if already banned
    if sudo ufw status | grep -q "$IP"; then
        echo "ℹ️ $IP is already in the jail cell."
    else
        # THE BAN: We use 'insert 1' to make sure it's the very first rule checked
        sudo ufw insert 1 deny from "$IP" to any
        echo "$(date): BANNED $IP for exceeding $THRESHOLD errors." >> "$JAIL_LOG"
        echo "🚫 BANNED: $IP has been blocked at the firewall."
    fi
done
