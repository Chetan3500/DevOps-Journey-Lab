#!/usr/bin/env bash

# 1. Ingredients (Threshold in Kilobytes: 10MB = 10240KB)
THRESHOLD=10240
LOG_FILE="/var/log/nginx/access.log"
BACKUP_DIR="/var/log/nginx/backups"

# 2. Preparation (Get current size in KB)
# 'cut' just grabs the first number from the du command
CURRENT_SIZE=$(du -k "$LOG_FILE" | cut -f1)

# 3. Action
if [ "$CURRENT_SIZE" -gt "$THRESHOLD" ]; then
    echo "Log is $CURRENT_SIZE KB. Rotating..."

    # Create backup dir if it doesn't exist
		if [ ! -d $BACKUP_DIR ]; then
			mkdir -p "$BACKUP_DIR"
		fi

    # Move the old log with a timestamp
    mv "$LOG_FILE" "$BACKUP_DIR/access.log.$(date +%F-%s)"

    # The "Gotcha" Fix: Re-create the file and tell Nginx to wake up
    touch "$LOG_FILE"
    chmod 644 "$LOG_FILE"
    systemctl reload nginx

    echo "Rotation complete."
else
    echo "Log size is fine."
fi
