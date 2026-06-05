#!/bin/bash

set -euo pipefail

TARGET=${1:-rpi-target-01}

TARGET_IP=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET ip
)

TARGET_UART=$(
    ~/hwlab/scripts/get_target_info.py \
    $TARGET uart
)



LOCKFILE=/tmp/hwlab_pipeline_$TARGET.lock

cleanup() {

    RESULT=$?

    rm -f "$LOCKFILE"

    if [ $RESULT -ne 0 ]; then

        ~/hwlab/scripts/set_state.sh \
        $TARGET FAILED

    fi

}


trap cleanup EXIT

if [ -f "$LOCKFILE" ]; then

    echo "[!] Pipeline already running"
    exit 1

fi

touch "$LOCKFILE"





RUN_ID=$(date +%Y%m%d-%H%M%S)

RUN_DIR=~/hwlab/history/$TARGET/$RUN_ID

TARGET_LOG_DIR=~/hwlab/logs/$TARGET

TARGET_STATE_DIR=~/hwlab/state/$TARGET


mkdir -p $TARGET_LOG_DIR
mkdir -p $TARGET_STATE_DIR

touch $TARGET_LOG_DIR/target.log

mkdir -p $RUN_DIR

echo "======================================="
echo "[*] HWLAB PIPELINE"
echo "[*] RUN ID: $RUN_ID"
echo "======================================="

echo "[*] Cleaning old logs..."

rm -f $TARGET_LOG_DIR/target.log

echo "[*] Hard reboot target..."

~/hwlab/scripts/power_control.sh \
$TARGET OFF

echo "[*] Starting UART logger..."

touch $TARGET_LOG_DIR/target.log
pkill -f uart_orchestrator.py || true

touch $TARGET_LOG_DIR/target.log

nohup ~/hwlab/venv/bin/python \
~/hwlab/scripts/uart_orchestrator.py \
$TARGET \
> $TARGET_LOG_DIR/uart_orchestrator.stdout 2>&1 &

UART_PID=$!

echo "[+] UART logger PID: $UART_PID"

sleep 5

~/hwlab/scripts/power_control.sh \
$TARGET ON

echo "[*] Waiting UART stabilization..."

sleep 20

echo "[*] Waiting target boot..."

~/hwlab/scripts/set_state.sh $TARGET BOOTING

~/hwlab/scripts/wait_for_boot.sh \
$TARGET

echo "[*] Running boot validation..."

~/hwlab/scripts/check_boot.sh $TARGET

echo "[*] Waiting SSH..."

~/hwlab/scripts/set_state.sh $TARGET ONLINE

~/hwlab/scripts/wait_for_ssh.sh \
$TARGET

echo "[*] Running SSH validation..."

~/hwlab/scripts/check_ssh.sh \
$TARGET

# ==========================================
# FIRMWARE DEPLOY
# ==========================================

echo "[*] Deploying firmware..."

~/hwlab/scripts/set_state.sh \
$TARGET VALIDATING

echo "1.0.0" > \
$TARGET_STATE_DIR/previous_firmware

~/hwlab/scripts/deploy_firmware.sh \
$TARGET \
1.0.0

# ==========================================
# FIRMWARE VALIDATION
# ==========================================

echo "[*] Validating firmware..."

if ! ~/hwlab/scripts/validate_firmware.sh \
$TARGET
then

    ~/hwlab/scripts/rollback_firmware.sh \
    $TARGET

    exit 1

fi

echo "[*] Deploying app..."

~/hwlab/scripts/set_state.sh $TARGET DEPLOYING

~/hwlab/scripts/deploy.sh $TARGET

echo "[*] Running remote tests..."

~/hwlab/scripts/set_state.sh $TARGET TESTING

~/hwlab/scripts/run_remote_tests.sh \
$TARGET

echo "[*] Checking reboot loop..."

~/hwlab/scripts/check_reboot_loop.sh \
$TARGET

echo "[*] Checking system health..."

~/hwlab/scripts/check_system_health.sh \
$TARGET

echo "[*] Generating debug bundle..."

~/hwlab/scripts/debug_bundle.sh \
$TARGET

echo "[*] Generating report..."

~/hwlab/scripts/set_state.sh $TARGET REPORTING

~/hwlab/scripts/report.sh \
$TARGET

echo ""
echo "========== REPORT =========="
cat ~/hwlab/reports/$TARGET/latest.txt

echo ""
echo "[*] Saving artifacts..."

cp $TARGET_LOG_DIR/target.log $RUN_DIR/
cp ~/hwlab/reports/$TARGET/latest.txt \
$RUN_DIR/

echo "[*] Saving UART stdout..."

cp $TARGET_LOG_DIR/uart_orchestrator.stdout \
$RUN_DIR/ || true

echo "[*] Running final status..."

~/hwlab/scripts/final_status.sh \
$TARGET

~/hwlab/scripts/set_state.sh $TARGET SUCCESS

echo ""
echo "[+] PIPELINE COMPLETE"
