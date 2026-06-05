#!/usr/bin/env python3

import json
import sys
from pathlib import Path

# ==========================================
# USAGE
# ==========================================

if len(sys.argv) != 3:

    print(
        "Usage: get_target_info.py "
        "<target-name> <field>"
    )

    sys.exit(1)

TARGET_NAME = sys.argv[1]
FIELD = sys.argv[2]

# ==========================================
# LOAD TARGETS CONFIG
# ==========================================

TARGETS_FILE = Path(
    "/home/admin/hwlab/targets.json"
)

if not TARGETS_FILE.exists():

    print("[!] targets.json not found")

    sys.exit(1)

with open(TARGETS_FILE) as f:

    data = json.load(f)

# ==========================================
# FIND TARGET
# ==========================================

for target in data["targets"]:

    if target["name"] == TARGET_NAME:

        if FIELD not in target:

            print(
                f"[!] Field '{FIELD}' not found"
            )

            sys.exit(1)

        print(target[FIELD])

        sys.exit(0)

# ==========================================
# TARGET NOT FOUND
# ==========================================

print(
    f"[!] Target '{TARGET_NAME}' not found"
)

sys.exit(1)