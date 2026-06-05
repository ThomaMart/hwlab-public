#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./deploy.sh <target>"

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

echo "[*] Deploying testapp"

scp -r \
~/hwlab/projects/testapp \
$TARGET_USER@$TARGET_IP:/home/$TARGET_USER/

echo "[+] Deploy complete"

# ==========================================
# DEPLOY COUNT
# ==========================================

COUNT_FILE=~/hwlab/state/$TARGET/deploy_count

mkdir -p ~/hwlab/state/$TARGET

if [ ! -f "$COUNT_FILE" ]; then

    echo 0 > $COUNT_FILE

fi

COUNT=$(cat $COUNT_FILE)

COUNT=$((COUNT + 1))

echo $COUNT > $COUNT_FILE

echo "[+] Deploy count: $COUNT"