#!/bin/bash

# Must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (use sudo)"
  exit 1
fi

echo "🚀 Starting Lab Reset..."

# 1. Flush Firewall Rules (Remove the 'DROP' blocks)
echo "Cleaning up firewall rules..."
sudo iptables -F

# 2. Restore Nginx Permissions
echo "Restoring /var/log/nginx permissions..."
sudo chmod 755 /var/log/nginx

# 3. Ensure Nginx is running
echo "Restarting Nginx..."
sudo systemctl restart nginx

# 4. Verification
echo "✅ Lab Reset Complete. Current Status:"
sudo systemctl is-active nginx
sudo iptables -L -n | grep ":80" || echo "Port 80 is clear."
