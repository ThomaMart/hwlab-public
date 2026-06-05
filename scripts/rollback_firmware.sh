#!/bin/bash

set -euo pipefail

TARGET=$1

TARGET_STATE_DIR=~/hwlab/state/$TARGET

PREVIOUS_FW=$(
    cat $TARGET_STATE_DIR/previous_firmware
)

echo "[*] Rolling back firmware..."

echo "$PREVIOUS_FW" > \
$TARGET_STATE_DIR/current_firmware

echo "[+] Rollback complete"
