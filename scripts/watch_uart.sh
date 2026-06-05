#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./watch_uart.sh <target>"

    exit 1

fi

LOGFILE=~/hwlab/logs/$TARGET/target.log

if [ ! -f "$LOGFILE" ]; then

    echo "[!] Logfile not found:"
    echo "$LOGFILE"

    exit 1

fi

echo "[*] Watching UART logs..."
echo "[*] TARGET: $TARGET"
echo "[*] LOGFILE: $LOGFILE"
echo ""

tail -f $LOGFILE