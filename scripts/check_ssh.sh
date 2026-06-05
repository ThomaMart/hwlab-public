#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./check_ssh.sh <target>"

    exit 1

fi

TARGET_IP=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET ip
)

if nc -z $TARGET_IP 22; then

    echo "[+] SSH OK"

    exit 0

else

    echo "[-] SSH DOWN"

    exit 1

fi