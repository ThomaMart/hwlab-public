#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./validate_target.sh <target>"

    exit 1

fi

TARGET_IP=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET ip
)

TARGET_USER=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET user
)

echo "[*] Running validation..."
echo "[*] TARGET: $TARGET"
echo "[*] IP: $TARGET_IP"

# ==========================================
# HOSTNAME
# ==========================================

echo ""
echo "--- HOSTNAME ---"

ssh \
$TARGET_USER@$TARGET_IP \
"hostname"

# ==========================================
# UPTIME
# ==========================================

echo ""
echo "--- UPTIME ---"

ssh \
$TARGET_USER@$TARGET_IP \
"uptime"

# ==========================================
# SYSTEMD STATUS
# ==========================================

echo ""
echo "--- SYSTEM STATUS ---"

ssh \
$TARGET_USER@$TARGET_IP \
"systemctl is-system-running"

# ==========================================
# TEMPERATURE
# ==========================================

echo ""
echo "--- TEMPERATURE ---"

ssh \
$TARGET_USER@$TARGET_IP \
"vcgencmd measure_temp"

echo ""
echo "[+] Validation complete"