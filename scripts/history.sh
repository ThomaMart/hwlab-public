#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./history.sh <target>"

    exit 1

fi

HISTORY_DIR=~/hwlab/history/$TARGET

if [ ! -d "$HISTORY_DIR" ]; then

    echo "[!] No history found for:"
    echo "$TARGET"

    exit 1

fi

echo ""
echo "========== HISTORY =========="
echo "[*] TARGET: $TARGET"
echo ""

ls -1 $HISTORY_DIR