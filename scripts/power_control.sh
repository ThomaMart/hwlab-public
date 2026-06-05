#!/bin/bash

set -euo pipefail

TARGET=$1
ACTION=$2

TARGET_PLUG=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET plug_ip
)

echo "[*] Power $ACTION on $TARGET"

curl -s \
"http://$TARGET_PLUG/cm?cmnd=Power%20$ACTION"

echo "[+] Power command sent"