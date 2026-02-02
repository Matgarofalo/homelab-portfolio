# Project: Bare Metal Proxmox Hypervisor on Repurposed Secondhand Laptop

**Date:** August 2025

## 1. Project Overview
The objective of this project was to turn an old secondhand laptop into a functional Type 1 Hypervisor for my home lab. The purpose of which was to deploy enterprise-grade virtualization software and due to  constrained hardware, optimize resources and reduce bottlenecks.

## 2. Specs & Constraints
* **Device:** Intel Inside Laptop 
* **Original OS:** Windows 11 (Removed)
* **Constraints:**
    * **Heat Management:** This laptop is not designed for 24/7 up time.
    * **Single NIC:** Limited to one physical ethernet port (no dedicated management interface).
    * **Power Management:** Default behavior suspends the system when the lid is closed.
    * **Static IP:** `192.168.1.10/24`
   
## 3. Implementation Steps

### Phase 0: Hardware Restoration - Layer 1 Diagnostics
The device was initially retrieved from a scrap pile and failed to POST. No fan spin, no display, no LED indicators.
* **Diagnosis:** External power supply tested OK. Internal inspection showed no obvious damage.
* **Root Cause:** A critical ribbon cable was unseated inside the chassis.
* **Resolution:** Disassembled the chassis, reseated the connection, and verified a successful boot. This ended up salvaging a device that initial research suggested was trash.

### Phase 1: Bare Metal Installation
1.  **OS Removal:** Formatted the existing Windows 11 partition to ensure a clean environment and used Ext4 for the root filesystem to ready the primary boot drive with the standard Proxmox LVM layoyt.
2.  **Boot Media:** Created a bootable Proxmox VE USB installer.
3.  **Hypervisor Install:** Installed Proxmox VE directly on bare metal replacing the OS, not running inside it.
    * *Result:* Converted a previously useless consumer device into a dedicated virtualization server.

### Phase 2: Post-Installation Configuration 
Since the device is a laptop, standard server behaviors had to be forced via the command line.

**A. Lid Close Override**
To allow the server to run with the lid closed, I modified the systemd login configuration.
* **File Edited:** `/etc/systemd/logind.conf`
* **Configuration:** Set `HandleLidSwitch=ignore`
* **Command:** `systemctl restart systemd-logind`

**B. Remote Management**
Once the network interface was up, all further configuration was performed remotely via SSH from a Fedora workstation.
* Established a secure SSH handshake.
* Managed storage and VM creation via the Proxmox Web GUI (Port 8006).

**C. Power Efficiency (Wake-on-LAN)**
To reduce power usage and thermal stress, I configured Wake-on-LAN (WoL) to allow the node to be hibernated and woken up remotely and on demand.
1.  **BIOS:** Enabled "Wake on LAN" in the boot firmware.
2.  **Network Interface:** Verified support via `ethtool` (Checked for `Supports Wake-on: g`).
3.  **Proxmox Node:** Enabled WoL in the node options to support "Magic Packets" from the network controller.

### Phase 3: Troubleshooting

**A. Boot Settings**
1. **Diagnostics** After installation, the device refused to boot, looping back to the BIOS or failing to find the bootloader. Vendor documentation was non-existent for Linux support. Online forums and AI tools provided generic advice that failed to resolve the issue.
2. **Solution:** I performed a manual, line-by-line audit of the BIOS menu. I eventually located a hidden, undocumented submenu containing a **"Platform OS Type"** toggle. Switching this from `Windows` to `Linux` allowed the proprietary Aptio firmware to hand off the boot process to GRUB.
 **B. Network Configuration**
1. The initial default static IP was outside the working subnet, preventing network access.
2. The `/etc/network/interfaces` file was manually edited via the CLI with `vim` to correct the **Address** (`192.168.1.10/24`) and **Gateway** (`192.168.1.1`).
3. The crucial **`bridge-ports`** line was corrected to link the virtual bridge (`vmbr0`) to the physical interface (`nic0`), ensuring network traffic could pass into the operating system.
4. **Result:** The server's internal network configuration was verified as correct.
