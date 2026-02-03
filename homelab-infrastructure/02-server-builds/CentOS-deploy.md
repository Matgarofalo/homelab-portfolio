# Project: CentOS Web Server Deployment & Hardening

**Date:** September 2025

## 1. Executive Summary
Deployed and hardened a CentOS Stream 9 web server to host a static business website template for editing and developing. The objective was to execute a full CLI-based deployment, focusing on service persistence, firewall access control lists (ACLs), and strict filesystem permission management to fix HTTP 403 Forbidden errors.

## 2. Infrastructure Specs
* **Hypervisor:** VMware
* **OS:** CentOS Stream 9 (CLI Only)
* **Service:** Apache HTTPD
* **Networking:** Static IP (`192.168.220.150`) with local DNS mapping.

## 3. Implementation Log
* **Package Management:** Deployed `httpd` via `dnf` and configured systemd service units for immediate start and boot persistence (`systemctl enable --now`).
* **Network Config:** Verified interface up-status and established static addressing for consistent local access.
* **Content Deployment:** Transferred static assets (HTML/CSS) via SCP and mapped local DNS to `therustynailcarpentry.com` for staging simulation.

## 4. Troubleshooting & Security Hardening
During deployment, two security mechanisms correctly blocked access, requiring specific administrative overrides.

### A. Firewall Zone Management
* **Issue:** The web service was active (systemd status "Active/Running"), but external browsers timed out.
* **Diagnosis:** `firewall-cmd --list-all` confirmed the `public` zone lacked an allow rule for port 80/tcp.
* **Resolution:** Modified the permanent firewall configuration to permit HTTP traffic, followed by a zone reload.
    ```bash
    sudo firewall-cmd --add-service=http --permanent
    sudo firewall-cmd --reload
    ```

### B. Access Control
* **Issue:** Browser requests returned **HTTP 403 Forbidden**.
* **Diagnosis:** Review of directory permissions revealed that the deployed files were owned by the `root` user (from the upload process), preventing the Apache process user (`apache`) from reading the content.
* **Resolution:** Executed recursive ownership transfer to the web service user.
    ```bash
    sudo chown -R apache:apache /var/www/html/carpentry/
    ```
