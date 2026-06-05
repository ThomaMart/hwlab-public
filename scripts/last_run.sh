#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./last_run.sh <target>"

    exit 1

fi

HISTORY_DIR=~/hwlab/history/$TARGET

if [ ! -d "$HISTORY_DIR" ]; then

    echo "[!] No history for target:"
    echo "$TARGET"

    exit 1

fi

LAST=$(
    ls -1 $HISTORY_DIR | tail -1
)

echo ""
echo "========== LAST RUN =========="
echo "[*] TARGET: $TARGET"
echo "[*] RUN: $LAST"
echo ""

REPORT_FILE=$HISTORY_DIR/$LAST/latest.txt

if [ ! -f "$REPORT_FILE" ]; then

    echo "[!] latest.txt not found"

    exit 1

fi

cat $REPORT_FILE