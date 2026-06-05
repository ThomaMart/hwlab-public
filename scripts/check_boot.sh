#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./check_boot.sh <target>"

    exit 1

fi

LOG=~/hwlab/logs/$TARGET/target.log

# ==========================================
# BOOT OK
# ==========================================

if grep -q \
"LOGIN PROMPT DETECTED" \
"$LOG"; then

    echo "[+] BOOT OK"

    exit 0

fi

# ==========================================
# KERNEL PANIC
# ==========================================

if grep -q \
"KERNEL PANIC DETECTED" \
"$LOG"; then

    echo "[-] KERNEL PANIC"

    exit 1

fi

# ==========================================
# STILL BOOTING
# ==========================================

echo "[*] Boot still running"

exit 2