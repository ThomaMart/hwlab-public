#!/bin/bash

set -euo pipefail

TARGET=$1

TARGET_IP=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET ip
)

CURRENT_FW=$(
    cat ~/hwlab/state/$TARGET/current_firmware
)

MANIFEST=~/hwlab/firmware/releases/$CURRENT_FW/manifest.json

EXPECTED_KERNEL=$(
    jq -r '.kernel' $MANIFEST
)

EXPECTED_OS=$(
    jq -r '.os' $MANIFEST
)

EXPECTED_ARCH=$(
    jq -r '.architecture' $MANIFEST
)

CURRENT_KERNEL=$(
    ssh lab@$TARGET_IP uname -r
)

CURRENT_OS=$(
    ssh lab@$TARGET_IP \
    "grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '\"'"
)

CURRENT_ARCH=$(
    ssh lab@$TARGET_IP uname -m
)

echo "[*] Validating firmware..."

# ==========================================
# KERNEL
# ==========================================

if [ "$CURRENT_KERNEL" != "$EXPECTED_KERNEL" ]; then

    echo "[-] Kernel mismatch"

    echo "Expected: $EXPECTED_KERNEL"
    echo "Current : $CURRENT_KERNEL"

    exit 1

fi

echo "[+] Kernel OK"

# ==========================================
# OS
# ==========================================

if [ "$CURRENT_OS" != "$EXPECTED_OS" ]; then

    echo "[-] OS mismatch"

    echo "Expected: $EXPECTED_OS"
    echo "Current : $CURRENT_OS"

    exit 1

fi

echo "[+] OS OK"

# ==========================================
# ARCH
# ==========================================

if [ "$CURRENT_ARCH" != "$EXPECTED_ARCH" ]; then

    echo "[-] Architecture mismatch"

    echo "Expected: $EXPECTED_ARCH"
    echo "Current : $CURRENT_ARCH"

    exit 1

fi

echo "[+] Architecture OK"

echo "[+] Firmware validation SUCCESS"