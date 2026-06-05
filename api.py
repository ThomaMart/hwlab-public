#!/usr/bin/env python3

from fastapi import FastAPI
from pathlib import Path
import subprocess

app = FastAPI()

BASE_DIR = Path(__file__).resolve().parent

STATE_FILE = BASE_DIR / "state" / "current_state"

REPORT_FILE = BASE_DIR / "reports" / "latest.txt"


@app.get("/")
def root():

    return {
        "service": "hwlab",
        "status": "online"
    }


@app.get("/state")
def state():

    if not STATE_FILE.exists():
        return {"state": "UNKNOWN"}

    return {
        "state": STATE_FILE.read_text().strip()
    }


@app.get("/report")
def report():

    if not REPORT_FILE.exists():
        return {"report": "missing"}

    return {
        "report": REPORT_FILE.read_text()
    }


@app.post("/run")
def run_pipeline():

    subprocess.Popen(
        ["/home/admin/hwlab/scripts/run_pipeline.sh"]
    )

    return {
        "status": "pipeline started"
    }


@app.post("/reboot")
def reboot_target():

    subprocess.Popen([
        "ssh",
        "lab@TARGET_IP",
        "sudo reboot"
    ])

    return {
        "status": "reboot sent"
    }
