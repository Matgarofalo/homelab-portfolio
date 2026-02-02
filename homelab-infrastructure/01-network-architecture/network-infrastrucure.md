# Project: Network Infrastructure & Security Hardening

**Date:** October 2025
 
## 1. Project Overview

This document details the topology and configurations of my home lab set up. The primary objective was to establish a professional network architecture capable of supporting virtualization, enterprise testing, and reliable daily operations, while studying for CompTIA A+ and CCNA certifications.

## 2. Network Topology & Hardware
* **ISP Connection:** Fiber Optic (WAN)
* **Gateway/Router:** Netgear Nighthawk R7000 (AC1900)
  * *Role:* DHCP Server, Gateway, Firewall, Wireless Access Point.
* **Core Switching:** TP-Link TL-SG108E (8-Port Managed Gigabit Switch)
  * *Role:* Layer 2 Traffic Management, physical segmentation.
* **Endpoints:**
  * **Wired (Full-Duplex):** Proxmox Hypervisor, Main Workstation- Lenovo Thinkpad 32GB RAM, Admin Workstation (iMac), Printer, Storage Server.
  * **Wireless (Half-Duplex):** Mobile devices, IoT (Roku, Sonos, Ring Camera), Guest devices.


## 3. Naming Convention
Transitioned from default factory hostnames (e.g., `BRN3C...`) to a standardized enterprise convention:
**Format:** `[DeviceType]-[Location]-[Function]`
* *Example:* `SRV-PVE-NODE1` (Server - Proxmox VE - Node 1)
* *Example:* `WS-OFFICE-ADMIN` (Workstation - Office - Administrator)

## 4. IP Address Schema (DHCP & Reservations)
Implemented a **Class C** private network (`192.168.1.0/24`) with a segmented IP allocation situation that simplifies management and device identification.

| IP Range | Zone / Function | Rationale |
| :--- | :--- | :--- |
| **.1 - .9** | **Network Infrastructure** | Critical appliances (Router, Switches, APs). |
| **.10 - .29** | **Servers & Virtualization** | Static IPs for consistent SSH/Web GUI access. |
| **.30 - .39** | **Peripherals** | Printers and Scanners (Wired). |
| **.40 - .49** | **Admin Workstations** | Primary management PCs. |
| **.50 - .254** | **DHCP Pool** | Mobile devices, IoT, and Guest clients. |

## 4. Device Inventory & Reservations
*Verified via MAC Address OUI lookup and Fedora terminal (`ip addr`, `arp -a`).*

| Device Name | Role | IP Address | Connection |
| :--- | :--- | :--- | :--- |
| **Nighthawk R7000** | Gateway | `192.168.1.1` | WAN/LAN |
| **SWITCH-LAB-CORE** | Core Switch | `192.168.1.2` | Wired |
| **SRV-PVE-NODE1** | Hypervisor | `192.168.1.10` | Wired |
| **SRV-NAS-01** | Storage | `192.168.1.28` | Wired |
| **PRT-OFFICE-BROTHER** | Printer | `192.168.1.30` | Wired |
| **WS-OFFICE-ADMIN** | Admin Mac | `192.168.1.40` | Wired |
| **WS-LAB-THKPD** | Admin Linux | `192.168.1.41` | Wireless |

## 5. Security & Operational Procedures
* **MAC Randomization Disabled:** Disabled "Private Wi-Fi Address" features on reliable lab assets (ThinkPad, iPhones) to ensure my network security policies and IP reservations.
* **Documentation Redaction:** Applied data minimization principles for public documentation by redacting **WAN IP** (DDoS prevention) and **MAC Addresses** using KDE Spectacle and solid block redaction.
* **Physical Connectivity:** Prioritized Ethernet connectivity for stationary assets to utilize Full-Duplex communication and reduce Wi-Fi airtime congestion.
* **QoS (Quality of Service):** Configured prioritization rules to ensure Lab traffic (large file transfers) does not degrade VoIP/Streaming performance for other users.
* **VLAN Segmentation:** Configured the Managed Switch to logically separate IoT traffic from the Lab environment.


## 6. Core Skills/Tools Demonstrated
* **TCP/IP Addressing:** Subnetting analysis and DHCP reservation management.
* **Network Mapping:** Logical vs. Physical topology planning.
* **Operational Security:** Data minimization in documentation and secure device naming conventions.
* **Linux Networking:** Using CLI tools (`ip addr`, `arp`, `nmap`) for device discovery and verification.
* **QoS (Quality of Service):** Configure prioritization rules to ensure Lab traffic (large file transfers) does not degrade VoIP/Streaming performance for other users.
* **VLAN Segmentation:** Configure the Managed Switch to logically separate IoT traffic from the Lab environment.
