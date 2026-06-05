#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./boot_time.sh <target>"

    exit 1

fi

LOGFILE=~/hwlab/logs/$TARGET/target.log

START=$(
    grep "Run /init as init process" \
    $LOGFILE | head -1
)

END=$(
    grep "login:" \
    $LOGFILE | tail -1
)

echo "[*] Boot markers:"
echo "$START"
echo "$END"
