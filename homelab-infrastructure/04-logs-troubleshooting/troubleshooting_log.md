# Engineering Log: Roadblocks & Resolutions

This log documents specific technical challenges encountered during the lab build and the methodology used to resolve them.

## Incident 005: Proxmox Root Partition Saturation ("The Ghost File")
**Date:** December 27, 2025
**Problem:**
Attempting to migrate a VM disk to external storage caused the root filesystem (`/`) to hit 100% usage, crashing the web GUI.
**Root Cause:**
The external drive was not mounted permanently. When the server rebooted, the mount point `/srv/storage/ssd` became a standard folder on the small 8GB boot drive. The migration wrote data until the OS choked.
**Resolution:**
1.  Identified the "Ghost Files" using `du -xhd 1 /` to locate the hidden data in `/var/lib/vz`.
2.  Cleared the overflow data to restore system stability.
3.  Identified the drive UUID using `blkid`.
4.  Edited `/etc/fstab` to permanently mount the UUID to `/srv/storage/ssd` on boot.
5.  Successfully migrated the Windows VM disk (`qcow2`) to the now-stable external storage.

## Incident 004: Kali Linux Guest Agent Failure
**Date:** December 27, 2025
**Problem:**
The Kali Linux VM could not be shut down gracefully from the Proxmox GUI, and IP addresses were not reporting to the dashboard. Systemd reported "Dependency job failed" when trying to enable `qemu-guest-agent`.
**Root Cause:**
The QEMU Guest Agent software was installed in the OS, but the *virtual hardware channel* (VirtIO serial) was disabled in the hypervisor settings.
**Resolution:**
1.  Powered down the VM.
2.  Enabled "QEMU Guest Agent" in Proxmox VM Options.
3.  Rebooted VM; the agent service auto-started upon detecting the hardware channel.

## Incident 003: Windows 11 Connectivity & Firewall Blocks
[cite_start]**Context:** Proxmox Windows 11 Enterprise Setup [cite: 1, 10]
**Problem:**
The Windows VM failed to respond to external ping tests (`8.8.8.8`) and internal lateral movement tests (`10.10.10.2`) despite having a valid IP.
**Root Cause:**
Default Windows Defender Firewall rules block ICMP (Ping) requests on Public/Private profiles, creating a "Stealth Mode" effect.
**Resolution:**
1.  Stabilized the Remote Desktop Service (`TermService`) to allow administration.
2.  Configured an Outbound Rule in Windows Defender Firewall to explicitly allow ICMPv4 traffic.
3.  Verified connectivity via command line `ping` tests.

## Incident 002: Proxmox Server Boot Failure (Firmware Incompatibility)
[cite_start]**Context:** Initial Server Provisioning [cite: 3, 4]
**Problem:**
The repurposed Intel laptop failed to boot the Proxmox installer, freezing immediately after the GRUB menu.
**Root Cause:**
The proprietary Aptio UEFI/BIOS had a hidden "Platform OS" setting defaulted to Windows, which prevented the Linux kernel from initializing correctly.
**Resolution:**
1.  Located the hidden BIOS setting for "Platform OS Type".
2.  Switched setting to **Linux**.
3.  Server successfully completed POST and loaded the Proxmox kernel.

## Incident 001: Fedora Kernel vs. VMware Incompatibility
[cite_start]**Context:** Workstation Migration (Fedora Linux 6.17) [cite: 14]
**Problem:**
After migrating the host laptop to Fedora, VMware Workstation failed to launch due to kernel module compilation errors (`vmmon` module).
**Root Cause:**
The installed version of VMware was incompatible with the newer Linux Kernel 6.17 API changes.
**Resolution:**
1.  Manually removed the legacy VMware installation.
2.  Performed a clean install of VMware Workstation Pro 25H2, which contains the updated kernel modules required for Fedora's modern kernel.
