#!/bin/bash

SERVICE="nginx"

# 1. Check if service is active
if ! systemctl is-active --quiet $SERVICE; then
    echo "$(date): $SERVICE is DOWN. Investigating..."

    # 2. Check dmesg for OOM signatures
    if sudo dmesg | tail -n 50 | grep -i "killed process"; then
        echo "⚠️  Alert: $SERVICE was killed by OOM Killer!"
    fi

    # 3. Attempt Recovery
    echo "Attempting to restart $SERVICE..."
    sudo systemctl start $SERVICE
else
    echo "$(date): $SERVICE is healthy."
fi
