#!/usr/bin/env python3

from prometheus_client import (
    start_http_server,
    Gauge
)

from pathlib import Path

import psutil
import os
import json
import time

# ==========================================
# LOAD TARGETS
# ==========================================

TARGETS_FILE = Path(
    "/home/admin/hwlab/targets.json"
)

with open(TARGETS_FILE) as f:

    data = json.load(f)

TARGETS = data["targets"]

# ==========================================
# METRICS
# ==========================================

boot_time = Gauge(
    "hwlab_boot_time_seconds",
    "Target boot time",
    ["target"]
)

target_online = Gauge(
    "hwlab_target_online",
    "Target online state",
    ["target"]
)

pipeline_state = Gauge(
    "hwlab_pipeline_state",
    "Pipeline state",
    ["target"]
)

kernel_panic = Gauge(
    "hwlab_kernel_panic",
    "Kernel panic detected",
    ["target"]
)

reboot_count = Gauge(
    "hwlab_reboot_count",
    "Target reboot count",
    ["target"]
)

deploy_count = Gauge(
    "hwlab_deploy_count",
    "Total deploy count",
    ["target"]
)

cpu_usage = Gauge(
    "hwlab_cpu_usage_percent",
    "CPU usage percent"
)

ram_usage = Gauge(
    "hwlab_ram_usage_percent",
    "RAM usage percent"
)

swap_usage = Gauge(
    "hwlab_swap_usage_percent",
    "SWAP usage percent"
)

disk_usage = Gauge(
    "hwlab_disk_usage_percent",
    "Disk usage percent"
)

load_average = Gauge(
    "hwlab_load_average",
    "System load average"
)

temperature = Gauge(
    "hwlab_cpu_temperature_celsius",
    "CPU temperature"
)


        
kernel_version = Gauge(
    "hwlab_kernel_version_info",
    "Kernel version info",
    ["version"]
)

kernel_version.labels(
    version=os.uname().release
).set(1)

uptime_metric = Gauge(
    "hwlab_uptime_seconds",
    "System uptime"
)

with open("/proc/uptime") as f:

    uptime = float(f.read().split()[0])

uptime_metric.set(uptime)

process_count = Gauge(
    "hwlab_process_count",
    "Running process count"
)

process_count.set(
    len(psutil.pids())
)

# ==========================================
# START EXPORTER
# ==========================================

start_http_server(9200)

print(
    "[+] Metrics exporter running on :9200"
)

# ==========================================
# MAIN LOOP
# ==========================================

while True:

    for target in TARGETS:

        target_name = target["name"]

        STATE_DIR = Path(
            f"/home/admin/hwlab/state/"
            f"{target_name}"
        )

        # ==================================
        # FILES
        # ==================================

        STATE_FILE = (
            STATE_DIR / "current_state"
        )

        BOOT_FILE = (
            STATE_DIR / "boot_time.txt"
        )

        PANIC_FILE = (
            STATE_DIR / "kernel_panic"
        )

        REBOOT_FILE = (
            STATE_DIR / "reboot_count"
        )

        DEPLOY_FILE = (
            STATE_DIR / "deploy_count"
        )

        # ==================================
        # BOOT TIME
        # ==================================

        if BOOT_FILE.exists():

            value = float(
                BOOT_FILE.read_text().strip()
            )

            boot_time.labels(
                target=target_name
            ).set(value)

        # ==================================
        # TARGET ONLINE
        # ==================================

        if STATE_FILE.exists():

            state = (
                STATE_FILE
                .read_text()
                .strip()
            )

            ONLINE_STATES = [
                "ONLINE",
                "DEPLOYING",
                "TESTING",
                "REPORTING",
                "SUCCESS"
            ]

            if state in ONLINE_STATES:

                target_online.labels(
                    target=target_name
                ).set(1)

            else:

                target_online.labels(
                    target=target_name
                ).set(0)

        # ==================================
        # KERNEL PANIC
        # ==================================

        if PANIC_FILE.exists():

            kernel_panic.labels(
                target=target_name
            ).set(1)

        else:

            kernel_panic.labels(
                target=target_name
            ).set(0)

        # ==================================
        # REBOOT COUNT
        # ==================================

        if REBOOT_FILE.exists():

            count = int(
                REBOOT_FILE
                .read_text()
                .strip()
            )

            reboot_count.labels(
                target=target_name
            ).set(count)

        # ==================================
        # DEPLOY COUNT
        # ==================================

        if DEPLOY_FILE.exists():

            count = int(
                DEPLOY_FILE
                .read_text()
                .strip()
            )

            deploy_count.labels(
                target=target_name
            ).set(count)

        STATE_VALUES = {

            "OFFLINE": 0,
            "BOOTING": 1,
            "ONLINE": 2,
            "VALIDATING": 3,
            "DEPLOYING": 4,
            "TESTING": 5,
            "REPORTING": 6,
            "SUCCESS": 7,
            "FAILED": 8,
            "PANIC": 9,
        }


        if STATE_FILE.exists():

            current_state = (
                STATE_FILE
                .read_text()
                .strip()
            )

            value = STATE_VALUES.get(
                current_state,
                0
            )

            pipeline_state.labels(
                target=target_name
            ).set(value)

        # ==================================
        # CHECK SYSTEM HEALTH
        # ==================================


        cpu_usage.set(
            psutil.cpu_percent(interval=1)
        )

        ram_usage.set(
            psutil.virtual_memory().percent
        )

        swap_usage.set(
            psutil.swap_memory().percent
        )

        disk_usage.set(
            psutil.disk_usage("/").percent
        )

        load_average.set(
            os.getloadavg()[0]
        )

        try:

            with open(
                "/sys/class/thermal/thermal_zone0/temp"
            ) as f:

                temp = int(f.read()) / 1000

                temperature.set(temp)

        except:

            pass


        kernel_version.labels(
            version=os.uname().release
        ).set(1)

        uptime_metric.set(uptime)

        process_count.set(
            len(psutil.pids())
        )
        


    time.sleep(2)