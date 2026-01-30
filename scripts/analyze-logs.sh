#!/usr/bin/env bash

LOG="/var/log/nginx/access.log"

echo "--------------------------------------"
echo "Time: $(date)"

echo "--------------------------------------"
echo "          Top 5 IP Addresses          "
echo "--------------------------------------"

awk '{print $1}' $LOG | sort | uniq -c | sort -rn | head -5

echo "--------------------------------------"
echo "Total 404 Count : $(grep -c 404 $LOG)"
echo "--------------------------------------"

# Get the top talker (just the first line)
top_entry=$(awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -1)

# Split the entry into Count and IP
count=$(echo $top_entry | awk '{print $1}')
ip=$(echo $top_entry | awk '{print $2}')

# The Threshold Logic
THRESHOLD=50

if [ "$count" -gt "$THRESHOLD" ]; then
    sudo echo "$(date): ⚠️ ALERT! High traffic from $ip ($count requests)" >> /var/log/sre-alerts.log
    # Pro SRE move: You could even trigger an iptables block here!
fi
