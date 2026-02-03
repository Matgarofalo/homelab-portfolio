# Homelab & Infrastructure Portfolio

**Created:** 04/08/2025
**Last Modified:** 02/02/2026

---

## Summary

This repository serves as the central documentation for the evolution of my home lab. Prior to persuing IT certifications and experience, I was working off of an ISP-provided router/modem and a chromebook shared with my wife. Since then I have gradually phased into a 32GB Thinkpad running Fedora along with a secondhand laptop converted to a Proxmox server with a segmented, virtualized network environment designed to be a dynamic, adaptive place to build, break, and learn all the topics in my studies in a hands-on manner.

## 2. Methodology & Tooling
* **Infrastructure:** Bare-metal virtualization (Proxmox VE) replacing previous Type-2 hypervisor setups (VMWare and VirtualBox).
* **Documentation:** Written and formatted with the assistance of AI tools to ensure syntax and standard professional structure then proofed, validated and edited by human eyes.
* **Scripting:** Automation logic and objective defined by me; syntax generated via documentation, research and AI, then audited line-by-line for security, validation and learning.

## 3. Repository Navigation
My documentation is modularized into three core domains:

### 📂 [homelab-infrastructure](./homelab-infrastructure)
**Infrastructure & Server Builds**
* **[Network Topology](./homelab-infrastructure/01-network-architecture/network-infrastructure.md):** VLAN segmentation, Firewall configuration, and Subnetting (192.168.1.0/24).
* **[Server Build (Proxmox Node)](./homelab-infrastructure/02-server-builds/PVE-node-config.md):** Proxmox VE Host (`SRV-PVE-NODE1`) configuration and resource allocation for VMs and LXCs.
* **[LXC Web Server](./homelab-infrastructure/02-server-builds/CentOS-deploy.md):** Lightweight container deployment for hosting the portfolio web stack.
* **[Bare Metal Recovery](./homelab-infrastructure/02-server-builds/Clonezilla-deploy.md):** Full disk imaging and restoration procedures (Clonezilla).

**Storage & Lab Reports**
* **[RAID 10 Implementation](./homelab-infrastructure/03-lab-reports/raid-setups/RAID-10.md):** Design and stress-testing of a high-performance striped mirror array in CentOS.
* **[RAID 5 Parity Logic](./homelab-infrastructure/03-lab-reports/raid-setups/RAID-5-Parity.md):** Distributed parity implementation and "Hot Spare" rebuild analysis.
* **[RAID 1 Mirror Recovery](./homelab-infrastructure/03-lab-reports/raid-setups/RAID-1-Mirror.md):** Troubleshooting advanced mirror corruption and manual "Break Mirror" recovery.
* **[RAID 0 Failure Analysis](./homelab-infrastructure/03-lab-reports/raid-setups/RAID-0-Stripe.md):** Destructive testing demonstrating catastrophic data loss.

**Troubleshooting**
* **[WinRE Volume Diagnostics](./homelab-infrastructure/04-logs-troubleshooting/WinRE_troubleshooting.md):** Root cause analysis of offline repair failures (Drive Letter Shift) in Windows Recovery Environment.
* **[Switch VLAN Config](./homelab-infrastructure/03-lab-reports/switch-vlan-config.md):** Configuration of 802.1Q tagging and firmware troubleshooting on TP-Link managed switches.

### 📂 [lab-tools-scripts](./lab-tools-scripts)
**Automation**
* **[Linux Automation (Borg)](./lab-tools-scripts/01-linux/borg-backup/README.md):** Bash scripts for encrypted, deduplicated backups with retention policies.
* **[Nginx Deployment](./lab-tools-scripts/01-linux/nginx-deploy/README.md):** Scripted deployment pipeline for static web content.
* **[Windows Auditing](./lab-tools-scripts/02-windows/Win_Audit/README.md):** PowerShell tools for system health reporting and service monitoring.
* *Note: Scripts utilize `sudo` and administrative privileges. Review code before execution.*

### 📂 [web-development](https://github.com/Matgarofalo/matgarofalo.com)
**Web Development**
* Source code and configuration for my personal portfolio, company website, and other projects.
* Demonstrates Nginx reverse proxy implementation and static site deployment.

---

## 4. Core Skills Learned/Demonstrated
Through the construction of this lab, the following skills have been applied in a simulated production environment:

* **Virtualization Management:** Migration of VMs from VirtualBox/VMware to Proxmox KVM; management of LXC containers.
* **Linux Administration:** Package management (`apt`, `dnf`, `apk`), file system configuration (`fstab`/UUIDs), and permissions management (`chown`/`chmod`).
* **Network Architecture:** Configuration of Routers and Managed Switches (TP-Link), Static IP reservation, and DNS management (Cloudflare).
* **Disaster Recovery:** Implementation of automated backup strategies (Borg, Deja Dup, Clonezilla) and retention policies.
* **Security auditing:** Service status monitoring and external connectivity testing via TCP handshakes. Configured VLANs (802.1Q) on a managed switch to strictly isolate home lab traffic from the primary home network and conducted internal network reconnaissance using nmap to identify open ports and service versions.

---
