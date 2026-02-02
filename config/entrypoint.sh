#!/bin/bash
set -e

# 1. Fix permissions for the mounted volume data
# If /app/data is owned by root (ID 0), change it to volguard (ID 1000)
if [ "$(stat -c %u /app/data)" = "0" ]; then
    echo "Fixing volume permissions for /app/data..."
    chown -R volguard:volguard /app/data
    chown -R volguard:volguard /app/logs
fi

# 2. Run the application as the volguard user
echo "Starting VolGuard..."
# use 'runuser' or 'su-exec' to drop privileges
runuser -u volguard -- python -u volguard.py --mode auto --metrics-port 8080 --skip-confirm
