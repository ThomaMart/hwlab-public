#!/bin/bash

set -euo pipefail

echo "========== SYSTEM HEALTHCHECK =========="

echo ""
echo "[*] UPTIME"
uptime

echo ""
echo "[*] CPU / RAM"
free -h

echo ""
echo "[*] LOAD"
cat /proc/loadavg

echo ""
echo "[*] DISK"
df -h

echo ""
echo "[*] TEMPERATURE"
sensors || true

echo ""
echo "[*] NETWORK"
ip a

echo ""
echo "[*] FAILED SERVICES"
systemctl --failed || true

echo ""
echo "[*] KERNEL ERRORS"
journalctl -p err -b --no-pager | tail -20 || true

echo ""
echo "[*] DMESG"
if sudo -n true 2>/dev/null; then

    sudo dmesg -T | tail -20 || true

else

    echo "[!] dmesg requires sudo"

fi