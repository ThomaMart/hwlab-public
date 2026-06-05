#!/bin/bash

set -euo pipefail

TARGET=$1
VERSION=$2

TARGET_STATE_DIR=~/hwlab/state/$TARGET

echo "[*] Deploying firmware $VERSION"

echo "$VERSION" > \
$TARGET_STATE_DIR/current_firmware

echo "[+] Firmware deployed"
