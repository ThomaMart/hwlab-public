# 🔧 HWLAB — Hardware Integration & Embedded CI Lab

> Personal engineering project demonstrating Infrastructure Automation, Embedded Linux Integration, CI/CD Orchestration and Hardware Validation on real Raspberry Pi devices.

---

## ⚠️ Public Repository Notice

This repository is a public showcase version of HWLAB.

Some GitHub Actions workflows require access to the private Raspberry Pi validation laboratory and self-hosted runners. Therefore, workflow execution is intentionally disabled in the public version while preserving the CI/CD implementation for demonstration purposes.

---

# 🎯 Engineering Objectives

HWLAB was designed to reproduce real-world hardware integration challenges commonly encountered in embedded systems, infrastructure engineering and continuous validation environments.

The project addresses several key engineering topics:

* 🏗️ Infrastructure automation
* ⚙️ Bare-metal provisioning
* 🌐 Network boot architectures
* 🔄 Continuous Integration on physical devices
* 📡 Hardware observability
* 🚀 Automated firmware lifecycle management
* 🧪 Validation workflow industrialization
* 📈 Operational monitoring and reliability

The objective is to bridge the gap between software CI/CD practices and real embedded hardware validation.

---

# 🚀 Overview

HWLAB is a personal hardware integration and embedded CI platform designed to automate validation workflows on real devices.

The project focuses on:

* ⚙️ Hardware CI/CD orchestration
* 🌐 PXE / NFS boot infrastructure
* 📡 UART boot monitoring
* 🔐 SSH validation
* 🚀 Firmware deployment
* 🧪 Remote testing
* 📈 Infrastructure observability
* 🖥️ Multi-target orchestration

---

# 📊 Project Scale

* 🍓 3 Raspberry Pi devices
* 🌐 Dedicated validation network
* 📡 UART-based hardware orchestration
* ⚙️ 30+ automation scripts
* 📈 Real-time observability stack
* 🚀 Automated firmware validation workflows


---

# 💼 Engineering Skills Demonstrated

This project combines multiple disciplines usually distributed across different engineering roles.

## 🖥️ Infrastructure Engineering

* 🐧 Linux administration
* 🌐 DHCP / PXE / TFTP services
* 📂 NFS Root Filesystem
* 🔀 Network segmentation
* ⚙️ System orchestration

---

## ⚙️ Embedded Integration

* 🍓 Raspberry Pi provisioning
* 📡 UART debugging
* 🚀 Firmware deployment
* 👤 Boot process analysis
* 🔧 Hardware lifecycle management

---

## 🚀 DevOps & CI/CD

* 🐙 GitHub Actions
* ⚙️ Self-hosted runners
* 🔄 Automated validation pipelines
* 🚀 Continuous deployment workflows
* ♻️ Failure recovery procedures

---

## 📊 Site Reliability & Observability

* 📈 Prometheus monitoring
* 📊 Grafana dashboards
* 🧩 Metrics collection
* 🚨 Alert-oriented design
* 🖥️ Infrastructure health monitoring

---

# 📸 Hardware Lab

<img width="1448" height="1086" alt="hwlab" src="https://github.com/user-attachments/assets/f328f657-6a35-4e9a-8566-d8876f510b9c" />

## 🖥️ Physical Infrastructure

HWLAB is built around a dedicated embedded validation bench composed of:

* 🍓 Raspberry Pi orchestration master node
* 🎯 Multiple Raspberry Pi targets
* 🌐 Dedicated USB Ethernet adapters
* 📡 FT232 USB UART interfaces
* 🔌 Isolated validation networks
* 📂 PXE / NFS boot infrastructure
* ⚙️ Self-hosted CI runner

The lab is designed to validate real hardware workflows instead of virtualized environments.

---

# 🧩 Custom Hardware Integration

<img width="1668" height="1515" alt="Shapr3D" src="https://github.com/user-attachments/assets/6f000595-22e1-4aae-973a-5516a425ad98" />

To improve maintainability and reproducibility of the setup, a custom 3D-printed support was designed to integrate:

* 🌐 USB Ethernet adapters
* 📡 FT232 UART interfaces
* 🍓 Raspberry Pi targets
* 🔌 Structured cable routing

This allows:

* Faster hardware debugging
* Cleaner physical integration
* Easier maintenance
* Better cable management
* Improved accessibility during validation workflows

---

# 📊 Monitoring & Observability

<img width="1917" height="772" alt="Screenshot_2026-06-10_14-59-12" src="https://github.com/user-attachments/assets/f8eb6e12-87a6-4be7-99ee-89f1d80c7de6" />
<img width="1920" height="657" alt="Screenshot_2026-06-10_15-00-26" src="https://github.com/user-attachments/assets/a56b247f-b739-47d8-9f80-84fafb6a8ddb" />
<img width="1920" height="666" alt="Screenshot_2026-06-10_15-00-11" src="https://github.com/user-attachments/assets/ae36cd3f-ec21-472a-beb6-a64825e9bae2" />

HWLAB integrates a complete observability stack using:

* 📈 Prometheus
* 📊 Grafana
* 🧩 Custom hardware metrics exporter

### Example monitored metrics

* ⏱️ Target boot time
* 📊 Pipeline states
* 🟢 Target online status
* 🔁 Reboot counters
* 🚀 Deployment counters
* 💥 Kernel panic detection
* 🖥️ Infrastructure health

---

# ⚙️ CI/CD Integration

<img width="1327" height="545" alt="github_action2" src="https://github.com/user-attachments/assets/567798e6-716e-4e5d-b08c-b7bae22b2df8" />

The lab integrates directly with GitHub Actions using a self-hosted runner connected to real hardware targets.

Each pipeline can:

* 🔌 Power cycle targets
* 📡 Monitor UART output
* 👤 Detect login prompts
* 🔐 Validate SSH availability
* 🚀 Deploy firmware
* 🧪 Run remote validation scripts
* 📈 Export metrics
* 📝 Generate reports
* ♻️ Trigger rollback procedures

---

# 🏗️ Architecture

```text id="d3c7yu"
        GitHub Actions
              │
              ▼
    ┌─────────────────────┐
    │    HWLAB MASTER     │
    ├─────────────────────┤
    │ • DHCP Server       │
    │ • PXE / TFTP        │
    │ • NFS RootFS        │
    │ • UART Orchestrator │
    │ • Prometheus        │
    │ • Grafana           │
    │ • Self-hosted CI    │
    └─────────────────────┘
               │
    ┌──────────┴───────────┐
    ▼                      ▼

rpi-target-01       rpi-target-02
(SD Boot)           (PXE / NFS Boot)
```

---

# 🎯 Targets

| Target          | Boot Mode              | Purpose                         |
| --------------- | ---------------------- | ------------------------------- |
| `rpi-target-01` | 💾 SD Card             | Stable validation target        |
| `rpi-target-02` | 🌐 SD-less / PXE / NFS | Network boot integration target |

Both targets use dedicated USB Ethernet adapters and isolated subnets for deterministic networking and reproducible validation workflows.

---

# ✨ Features

## ⚡ Hardware Automation

* 🔌 Automated power control
* 🎯 Multi-target orchestration
* 📡 UART serial monitoring
* 👤 Boot state detection
* 🔐 SSH availability checks
* 🚀 Firmware deployment
* ♻️ Rollback management

---

## 🌐 PXE / NFS Infrastructure

* 🍓 Raspberry Pi network boot
* 📡 DHCP orchestration
* 📂 TFTP boot delivery
* 🗂️ Shared NFS root filesystem
* 🔀 Dedicated subnet isolation

---

## 📡 UART Orchestration

The UART orchestrator continuously analyzes serial output to:

* 👤 Detect login prompts
* 💥 Detect kernel panics
* ✅ Validate boot success
* ⏱️ Measure boot timings
* 📈 Feed Prometheus metrics

---

## 📈 Monitoring Stack

The monitoring infrastructure includes:

* 📊 Prometheus scraping
* 🧩 Custom hardware exporter
* 📈 Grafana dashboards
* 📜 Loki
* 📡 Promtail
* ⚙️ Pipeline metrics
* 🖥️ Infrastructure metrics
* 🟢 Hardware health tracking

---

# 🔄 Example Pipeline Flow

```text id="rjlwm4"
Power OFF target
       ↓
UART logger startup
       ↓
Power ON target
       ↓
Boot detection
       ↓
SSH validation
       ↓
Firmware deployment
       ↓
Remote tests
       ↓
Metrics export
       ↓
Report generation
```

---

# 🧰 Technologies

* 🐍 Python
* 🐚 Bash
* 🐙 GitHub Actions
* 📈 Prometheus
* 📊 Grafana
* 📜 Loki
* 📡 Promtail
* 🍓 Raspberry Pi
* 📡 UART / Serial
* 🌐 PXE / TFTP
* 📂 NFS
* ⚙️ systemd
* 🔌 Linux networking

---

# ✅ Current Status

Current infrastructure includes:

* ✅ Multi-target orchestration
* ✅ Dedicated hardware networking
* ✅ PXE boot support
* ✅ UART boot automation
* ✅ Automated hardware pipelines
* ✅ Monitoring dashboards
* ✅ Firmware deployment validation
* ✅ Metrics exporter integration
* ✅ Custom hardware support integration

---

# 👨‍💻 Author

Thomas Martin

Infrastructure, Embedded Linux and Hardware Integration Engineer.

This project was created to explore real-world infrastructure automation, hardware validation and observability practices using Raspberry Pi platforms and open-source technologies.
