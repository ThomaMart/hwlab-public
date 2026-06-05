#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./final_status.sh <target>"

    exit 1

fi

BOOT_OK=0
SSH_OK=0

~/hwlab/scripts/check_boot.sh \
$TARGET && BOOT_OK=1

~/hwlab/scripts/check_ssh.sh \
$TARGET && SSH_OK=1

echo ""
echo "========== FINAL STATUS =========="
echo "[*] TARGET: $TARGET"

if [ $BOOT_OK -eq 1 ] && \
   [ $SSH_OK -eq 1 ]; then

    echo "[+] PIPELINE SUCCESS"

    exit 0

fi

echo "[-] PIPELINE FAILED"

exit 1