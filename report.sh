#!/bin/bash

# --- CONFIGURATION ---
LOG_FILE="/var/log/nginx/access.log"
WEBHOOK_URL="https://canary.discord.com/api/webhooks/1459951341995692236/RH5aVDfiQNPVuLdUj8agyWf3Kj8x4YymGlq-iAXE46VimiCK9ZQP2YeOUTT5OhlNQIbe"

# --- DATA GATHERING ---
TIMESTAMP=$(date)
OFFENDERS=$(awk '$9 == 404 {print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5)
PATHS=$(awk '$9 == 404 {print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 5)
TRAFFIC=$(wc -l < "$LOG_FILE")

# --- CONSTRUCT REPORT ---
# We use a temporary variable to hold the text
TEXT_REPORT="📊 --- GATEKEEPER INTELLIGENCE REPORT --- 📊
Generated on: $TIMESTAMP
------------------------------------------
🚫 TOP 5 OFFENDERS (IPs triggering 404s):
${OFFENDERS:-"No offenders detected."}

📂 TOP 5 TARGETED PATHS:
${PATHS:-"No suspicious paths detected."}

📈 TOTAL TRAFFIC TODAY: $TRAFFIC
------------------------------------------"

# --- PRINT TO TERMINAL ---
echo "$TEXT_REPORT"

# --- SEND TO DISCORD (The Bulletproof Way) ---
# We use 'jq' or a simple 'sed' to escape the text for JSON safety
# This ensures newlines don't break the curl command
PAYLOAD=$(echo "$TEXT_REPORT" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}' | sed 's/\\n$//')

curl -H "Content-Type: application/json" \
     -X POST \
     -d "{\"content\": \"\`\`\`$PAYLOAD\`\`\`\"}" \
     "$WEBHOOK_URL"


