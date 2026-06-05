#!/bin/bash

set -euo pipefail

TARGET=${1:-debug}

OUT=~/hwlab/debug/${TARGET}_$(date +%Y%m%d-%H%M%S)

mkdir -p "$OUT"

echo "[*] Collecting debug bundle..."

uname -a > $OUT/uname.txt
uptime > $OUT/uptime.txt
free -h > $OUT/memory.txt
df -h > $OUT/disk.txt
ip a > $OUT/network.txt
journalctl -b > $OUT/journal.txt
if sudo -n true 2>/dev/null; then

    sudo dmesg -T > $OUT/dmesg.txt || true

else

    echo "[!] dmesg requires sudo" \
    > $OUT/dmesg.txt

fi
systemctl --failed > $OUT/failed_services.txt

sensors > $OUT/sensors.txt 2>/dev/null || true

echo "[+] Debug bundle saved:"
echo "$OUT"
