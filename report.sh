#!/bin/bash

LOG_FILE="/var/log/nginx/access.log"

echo "📊 --- GATEKEEPER INTELLIGENCE REPORT --- 📊"
echo "Generated on: $(date)"
echo "------------------------------------------"

# 1. Top 5 Attacking IP Addresses (404 errors)
echo "🚫 TOP 5 OFFENDERS (IPs triggering 404s):"
awk '$9 == 404 {print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -n 5
echo ""

# 2. Most Targeted Forbidden Paths
echo "📂 TOP 5 TARGETED PATHS:"
awk '$9 == 404 {print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -n 5
echo ""

# 3. Total Requests Today
echo "📈 TOTAL TRAFFIC TODAY:"
wc -l < $LOG_FILE
echo "------------------------------------------"
