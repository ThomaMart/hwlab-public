#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./log_uart.sh <target>"

    exit 1

fi

TARGET_UART=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET uart
)

LOG_DIR=~/hwlab/logs/$TARGET

mkdir -p $LOG_DIR

LOGFILE=$LOG_DIR/uart-$(date +%F-%H%M%S).log

echo "[*] TARGET: $TARGET"
echo "[*] UART: $TARGET_UART"
echo "[*] LOGFILE: $LOGFILE"
echo ""

cat $TARGET_UART | tee $LOGFILE