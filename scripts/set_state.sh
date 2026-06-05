#!/bin/bash

set -euo pipefail

TARGET=$1
STATE=$2

if [ -z "$TARGET" ] || \
   [ -z "$STATE" ]; then

    echo "Usage:"
    echo "./set_state.sh <target> <state>"

    exit 1

fi

STATE_DIR=~/hwlab/state/$TARGET
STATE_FILE=$STATE_DIR/current_state

mkdir -p $STATE_DIR

# ==========================================
# LOCK
# ==========================================

LOCKFILE=/tmp/hwlab_state_$TARGET.lock

exec 200>$LOCKFILE
flock -x 200

# ==========================================
# PROTECT FINAL STATES
# ==========================================

FINAL_STATES="SUCCESS FAILED PANIC"

CURRENT_STATE="NONE"

if [ -f "$STATE_FILE" ]; then

    CURRENT_STATE=$(cat "$STATE_FILE")

    for FINAL in $FINAL_STATES; do

        if [ "$CURRENT_STATE" = "$FINAL" ]; then

            echo "[STATE][$TARGET] FINAL STATE LOCKED ($CURRENT_STATE)"
            exit 0

        fi

    done

fi

# ==========================================
# UPDATE STATE
# ==========================================

echo "[DEBUG] $(date) PID=$$ CURRENT=$CURRENT_STATE NEW=$STATE"

echo $STATE > $STATE_FILE

echo "[STATE][$TARGET] $STATE"