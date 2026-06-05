#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./wait_for_ssh.sh <target>"

    exit 1

fi

TARGET_IP=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET ip
)

TIMEOUT=300

echo "[*] Waiting SSH..."
echo "[*] TARGET: $TARGET"
echo "[*] IP: $TARGET_IP"

for ((i=0; i<$TIMEOUT; i++)); do

    if nc -z $TARGET_IP 22; then

        echo "[+] SSH AVAILABLE"

        exit 0

    fi

    sleep 1

done

echo "[-] SSH TIMEOUT"

exit 1