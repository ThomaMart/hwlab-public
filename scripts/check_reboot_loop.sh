#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./check_reboot_loop.sh <target>"

    exit 1

fi

LOG=~/hwlab/logs/$TARGET/target.log

# ==========================================
# COUNT BOOT SEQUENCES
# ==========================================

COUNT=$(
    grep -c \
    "LOGIN PROMPT DETECTED" \
    "$LOG" || true
)

echo "[*] Boot count: $COUNT"

# ==========================================
# DETECT REBOOT LOOP
# ==========================================

if [ "$COUNT" -gt 3 ]; then

    echo "[-] REBOOT LOOP DETECTED"

    exit 1

fi

echo "[+] No reboot loop"

exit 0