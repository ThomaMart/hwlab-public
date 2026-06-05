#!/usr/bin/env python3

import serial
import time
import sys
import json

from pathlib import Path
from datetime import datetime

# ==========================================
# ARGUMENTS
# ==========================================

if len(sys.argv) != 2:

    print(
        "Usage: uart_logger.py <target>"
    )

    sys.exit(1)

TARGET = sys.argv[1]

# ==========================================
# LOAD TARGET CONFIG
# ==========================================

TARGETS_FILE = Path(
    "/home/admin/hwlab/targets.json"
)

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

LOG_DIR.mkdir(
    parents=True,
    exist_ok=True
)

LOGFILE = (
    LOG_DIR /
    f"uart-{datetime.now().strftime('%Y%m%d-%H%M%S')}.log"
)

# ==========================================
# UART CONNECT
# ==========================================

ser = serial.Serial(
    SERIAL_PORT,
    BAUDRATE,
    timeout=1
)

print(
    f"[+] UART logger started "
    f"on {SERIAL_PORT}"
)

print(f"[+] TARGET: {TARGET}")

print(f"[+] LOGFILE: {LOGFILE}")

# ==========================================
# MAIN LOOP
# ==========================================

while True:

    try:

        line = ser.readline().decode(
            errors="ignore"
        )

        if line:

            timestamp = datetime.now().strftime(
                "%Y-%m-%d %H:%M:%S"
            )

            output = (
                f"[{timestamp}] "
                f"[{TARGET}] "
                f"{line}"
            )

            print(output, end="")

            with open(LOGFILE, "a") as f:

                f.write(output)

    except Exception as e:

        print(f"[ERROR] {e}")

        time.sleep(1)