#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./wait_for_boot.sh <target>"

    exit 1

fi

LOG=~/hwlab/logs/$TARGET/target.log

TIMEOUT=300

echo "[*] Waiting for target boot..."
echo "[*] TARGET: $TARGET"

for ((i=0; i<$TIMEOUT; i++)); do

    # ======================================
    # LOGIN DETECTED
    # ======================================

    if grep -qi \
    "LOGIN PROMPT DETECTED" \
    "$LOG"; then

        echo "[+] LOGIN PROMPT DETECTED"

        exit 0

    fi

    # ======================================
    # KERNEL PANIC
    # ======================================

    if grep -q \
    "KERNEL PANIC DETECTED" \
    "$LOG"; then

        echo "[-] KERNEL PANIC DETECTED"

        exit 1

    fi

    sleep 1

done

echo "[-] BOOT TIMEOUT"

exit 1