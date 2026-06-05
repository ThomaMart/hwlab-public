#!/usr/bin/env python3

from fastapi import FastAPI
from pathlib import Path
import subprocess

app = FastAPI()

STATE_FILE = Path("/home/admin/hwlab/state/current_state")

REPORT_FILE = Path("/home/admin/hwlab/reports/latest.txt")


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
        "lab@10.10.0.100",
        "sudo reboot"
    ])

    return {
        "status": "reboot sent"
    }
