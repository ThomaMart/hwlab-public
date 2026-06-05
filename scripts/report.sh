#!/bin/bash

set -euo pipefail

TARGET=$1

if [ -z "$TARGET" ]; then

    echo "Usage:"
    echo "./report.sh <target>"

    exit 1

fi

REPORT_DIR=~/hwlab/reports/$TARGET

LOGFILE=~/hwlab/logs/$TARGET/target.log

mkdir -p $REPORT_DIR

REPORT=$REPORT_DIR/latest.txt

echo "========== HWLAB REPORT ==========" \
> $REPORT

echo "[*] TARGET: $TARGET" \
>> $REPORT

date >> $REPORT

echo "" >> $REPORT

# ==========================================
# SSH CHECK
# ==========================================

echo "--- SSH CHECK ---" \
>> $REPORT

~/hwlab/scripts/check_ssh.sh \
$TARGET >> $REPORT 2>&1

echo "" >> $REPORT

# ==========================================
# BOOT CHECK
# ==========================================

echo "--- BOOT CHECK ---" \
>> $REPORT

~/hwlab/scripts/check_boot.sh \
$TARGET >> $REPORT 2>&1

echo "" >> $REPORT

# ==========================================
# LAST UART LOGS
# ==========================================

echo "--- LAST UART LOGS ---" \
>> $REPORT

tail -20 $LOGFILE >> $REPORT

echo "" >> $REPORT

echo "[+] Report generated:"
echo "$REPORT"