#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./run_remote_tests.sh <target>"

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

echo "[*] Running remote tests..."
echo "[*] TARGET: $TARGET"
echo "[*] IP: $TARGET_IP"

ssh \
$TARGET_USER@$TARGET_IP \
"
cd ~/testapp
./test.sh
"

echo "[+] Remote tests complete"