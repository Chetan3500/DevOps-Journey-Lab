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
