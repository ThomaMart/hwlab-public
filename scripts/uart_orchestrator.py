#!/usr/bin/env python3

import serial
import time
import re
import os
import sys
import json

from pathlib import Path
from datetime import datetime
from serial.serialutil import SerialException

# ==========================================
# ARGUMENTS
# ==========================================

if len(sys.argv) != 2:

    print(
        "Usage: uart_orchestrator.py <target>"
    )

    sys.exit(1)

TARGET = sys.argv[1]

# ==========================================
# LOAD TARGET CONFIG
# ==========================================

TARGETS_FILE = Path(
    "/home/admin/hwlab/targets.json"
)

if not TARGETS_FILE.exists():

    print("[!] targets.json not found")

    sys.exit(1)

with open(TARGETS_FILE) as f:

    data = json.load(f)

TARGET_INFO = None

for target in data["targets"]:

    if target["name"] == TARGET:

        TARGET_INFO = target

        break

if TARGET_INFO is None:

    print(
        f"[!] Target '{TARGET}' not found"
    )

    sys.exit(1)

# ==========================================
# TARGET VARIABLES
# ==========================================

SERIAL_PORT = TARGET_INFO["uart"]

BAUDRATE = 115200

LOG_DIR = Path(
    f"/home/admin/hwlab/logs/{TARGET}"
)

STATE_DIR = Path(
    f"/home/admin/hwlab/state/{TARGET}"
)

LOG_DIR.mkdir(
    parents=True,
    exist_ok=True
)

STATE_DIR.mkdir(
    parents=True,
    exist_ok=True
)

LOGFILE = LOG_DIR / "target.log"

BOOT_START = None

LOGIN_DETECTED = False

PANIC_PATTERNS = [
    "Kernel panic",
    "Oops:",
    "Call trace:",
    "BUG:"
]

# ==========================================
# LOG FUNCTION
# ==========================================

def log(message):

    timestamp = datetime.now().strftime(
        "%Y-%m-%d %H:%M:%S"
    )

    output = (
        f"[{timestamp}] "
        f"[{TARGET}] "
        f"{message}"
    )

    print(output)

    with open(LOGFILE, "a") as f:

        f.write(output + "\n")

# ==========================================
# MAIN LOOP
# ==========================================

while True:

    try:

        print(
            f"[{TARGET}] "
            f"Connecting UART: "
            f"{SERIAL_PORT}"
        )

        ser = serial.Serial(
            SERIAL_PORT,
            BAUDRATE,
            timeout=1
        )

        print(
            f"[{TARGET}] UART connected"
        )

        os.system(
            f"~/hwlab/venv/bin/python "
            f"/home/admin/hwlab/scripts/state_manager.py "
            f"{TARGET} UART_CONNECTED"
        )

        # wake up serial console
        ser.write(b"\n")

        LAST_POKE = time.time()

        while True:

            try:

                # ==========================
                # UART KEEPALIVE
                # ==========================

                if time.time() - LAST_POKE > 10:

                    ser.write(b"\n")

                    LAST_POKE = time.time()

                    log(
                        "[EVENT] UART KEEPALIVE"
                    )

                # ==========================
                # READ UART
                # ==========================

                raw = ser.readline()

                try:

                    line = raw.decode(
                        "utf-8",
                        errors="ignore"
                    )

                except Exception:

                    continue

                line = line.strip()

                # remove ANSI escapes
                line = re.sub(
                    r'\x1b\[[0-9;]*[A-Za-z]',
                    '',
                    line
                )

                # remove non printable chars
                line = re.sub(
                    r'[^\x20-\x7E]',
                    '',
                    line
                )

                if not line:

                    continue

                log(line)

                # ==========================
                # INIT START
                # ==========================

                if (
                    "Run /init as init process"
                    in line
                ):

                    BOOT_START = time.time()

                    LOGIN_DETECTED = False

                    os.system(
                        f"~/hwlab/venv/bin/python "
                        f"/home/admin/hwlab/scripts/state_manager.py "
                        f"{TARGET} BOOTING"
                    )

                    log(
                        "[EVENT] INIT START DETECTED"
                    )

                # ==========================
                # LOGIN DETECTED
                # ==========================
                
                print(repr(line))

                if (
                    re.search(r"login\s*:", line, re.IGNORECASE)
                    and not LOGIN_DETECTED
                ):

                    LOGIN_DETECTED = True

                    current_state_file = (
                        STATE_DIR / "current_state"
                    )

                    FINAL_STATES = [
                        "SUCCESS",
                        "FAILED",
                        "PANIC"
                    ]

                    if current_state_file.exists():

                        current_state = (
                            current_state_file
                            .read_text()
                            .strip()
                        )

                    else:

                        current_state = "UNKNOWN"

                    if current_state not in FINAL_STATES:

                        os.system(
                            f"~/hwlab/venv/bin/python "
                            f"/home/admin/hwlab/scripts/state_manager.py "
                            f"{TARGET} ONLINE"
                        )


                    log(
                        "[EVENT] LOGIN PROMPT DETECTED"
                    )

                    count_file = (
                        STATE_DIR /
                        "reboot_count"
                    )

                    if not count_file.exists():

                        count_file.write_text("0")

                    count = int(
                        count_file.read_text().strip()
                    )

                    count += 1

                    count_file.write_text(
                        str(count)
                    )

                    # ==========================
                    # BOOT TIME
                    # ==========================

                    if BOOT_START:

                        duration = round(
                            time.time() -
                            BOOT_START,
                            2
                        )

                    else:

                        duration = 0

                    log(
                        f"[EVENT] "
                        f"BOOT TIME = "
                        f"{duration}s"
                    )

                    with open(
                        STATE_DIR /
                        "boot_time.txt",
                        "w"
                    ) as f:

                        f.write(str(duration))

                # ==========================
                # KERNEL PANIC
                # ==========================

                if any(
                    pattern in line
                    for pattern in PANIC_PATTERNS
                ):

                    os.system(
                        f"~/hwlab/venv/bin/python "
                        f"/home/admin/hwlab/scripts/state_manager.py "
                        f"{TARGET} PANIC"
                    )

                    log(
                        "[EVENT] "
                        "KERNEL PANIC DETECTED"
                    )

                    with open(
                        STATE_DIR /
                        "kernel_panic",
                        "w"
                    ) as f:

                        f.write("PANIC")

                # ==========================
                # REBOOT DETECTED
                # ==========================

                if "reboot:" in line:

                    log(
                        "[EVENT] "
                        "REBOOT DETECTED"
                    )

            except SerialException:

                log(
                    "[WARN] UART disconnected"
                )

                break

    except Exception as e:

        log(f"[ERROR] {e}")

    print(
        f"[{TARGET}] "
        "Reconnecting UART in 2 seconds..."
    )

    time.sleep(2)