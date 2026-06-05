#!/usr/bin/env python3

import sys

from pathlib import Path

# ==========================================
# ARGUMENTS
# ==========================================

if len(sys.argv) != 3:

    print(
        "Usage: state_manager.py "
        "<target> <state>"
    )

    sys.exit(1)

TARGET = sys.argv[1]
STATE = sys.argv[2]

# ==========================================
# STATE DIR
# ==========================================

STATE_DIR = Path(
    f"/home/admin/hwlab/state/{TARGET}"
)

STATE_DIR.mkdir(
    parents=True,
    exist_ok=True
)

STATE_FILE = (
    STATE_DIR / "current_state"
)

# ==========================================
# SET STATE
# ==========================================

def set_state(state):

    STATE_FILE.write_text(state)

    print(
        f"[STATE][{TARGET}] {state}"
    )

# ==========================================
# MAIN
# ==========================================

if __name__ == "__main__":

    set_state(STATE)