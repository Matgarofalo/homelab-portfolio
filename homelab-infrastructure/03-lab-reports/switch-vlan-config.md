# Project: Network Segmentation & VLAN Implementation

**Date:** November 2025

## 1. Executive Summary
Deployed a Managed Switch (TP-Link TL-SG108E) to implement Layer 2 network segmentation via 802.1Q VLANs. The objective was to strictly isolate Lab/Guest traffic from the Trusted home network, ensuring that vulnerable or experimental devices cannot laterally move to personal workstations.

## 2. Infrastructure Specs
* **Gateway:** Netgear Nighthawk R7000 (Gateway: `192.168.1.1`)
* **Switching:** TP-Link TL-SG108E (8-Port Managed)
* **VLAN Topology:**
    * **VLAN 1:** Default / Management
    * **VLAN 10:** Trusted Network (Personal Devices)
    * **VLAN 20:** Lab Network (Isolated Sandbox)

## 3. Implementation Log
* **Port Configuration:**
    * **Uplink (Port 8):** Configured as a **Trunk** carrying tagged traffic for VLANs 1, 10, and 20.
    * **Access Ports (Ports 2-3):** Assigned PVID 20 (Untagged) for Lab devices.
    * **Default Ports (Ports 1, 4-7):** Retained on VLAN 1 for general management.
* **Addressing:** Established a **DHCP Reservation** (`192.168.1.2`) on the router to lock the switch's management IP to a known address without modifying the device's local interface settings.

## 4. Troubleshooting & Provisioning Roadblocks
During the initial provisioning, two specific firmware/configuration failures were encountered and resolved.

### A. Management Plane Inaccessibility
* **Issue:** Upon connection, the switch failed to negotiate a DHCP lease and reverted to its fallback IP (`192.168.0.1`), placing it on a mismatched subnet.
* **Diagnosis:** Direct connection via static client IP (`192.168.0.10`) confirmed Layer 3 connectivity, but the web service was unresponsive (HTTP Connection Refused).
* **Resolution:** Executed a physical factory reset (10s hold). Device successfully pulled a lease (`192.168.1.5`) upon reboot.

### B. Firmware Instability (Static IP)
* **Issue:** Configuring a Static IP directly on the switch interface caused the web management service to crash repeatedly.
* **Resolution:** Reverted device to DHCP Client mode and enforced IP persistence via **MAC Address Reservation** on the upstream gateway.
* **Outcome:** Management interface stabilized at `192.168.1.2`.

## 5. Validation & Conclusion
* **Isolation Test:** A client connected to Port 2 (VLAN 20) attempted to ping the Trusted Gateway (`192.168.1.1`).
* **Result:** Request Timed Out.
* **Verdict:** Layer 2 isolation is active. Traffic from the Lab environment is successfully blocked from routing to the Trusted subnet.
