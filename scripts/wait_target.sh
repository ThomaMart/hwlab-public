#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./wait_target.sh <target>"

    exit 1

fi

TARGET_IP=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET ip
)

echo "[*] Waiting for SSH on $TARGET..."
echo "[*] IP: $TARGET_IP"

while ! nc -z -w 2 $TARGET_IP 22; do

    sleep 2

done

echo "[+] SSH available on $TARGET"