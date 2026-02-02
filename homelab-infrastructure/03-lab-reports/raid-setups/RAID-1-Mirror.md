# Project: RAID 1 Implementation & Recovery (Windows)

**Date:** October 2025

## 1. Project Overview
Deployed and stress-tested a software-based RAID 1 Mirrored Volume on a Windows 11 Enterprise virtual machine. The objective was to verify data redundancy and learn recovery procedures in a scenario where I find the array in a degraded state.

## 2. Infrastructure Specs
* **Hypervisor:** Oracle VirtualBox
* **OS:** Windows 11 Enterprise (64-bit)
* **Storage Topology:**
    * **Root Vol:** 60GB Virtual Disk (NTFS)
    * **Array Members:** 2x 10GB Virtual Disks (Dynamic Mirror)
    * **Spare:** 1x 10GB Virtual Disk (Hot Swap)

## 3. Implementation Log
* **Provisioning:** Initialized disks as GPT and converted to Dynamic Disks to support software mirroring.
* **Array Build:** Configured a new volume `(Drive F:)` via Disk Management, formatted as NTFS.
* **Validation:** Verified synchronous write operations and data integrity prior to failure testing.

## 4. Disaster Recovery Simulation
A critical hardware failure was simulated by physically detaching a member disk from the VM configuration.
1.  **Status Check:** Volume entered **"Failed Redundancy"** state. Data remained 100% accessible via the remaining plex.
2.  **Troubleshooting (Roadblock):** Standard "Reactivate Volume" and `diskpart` repair commands failed due to a corrupted configuration state on the virtual controller.
3.  **Resolution:** Executed a manual "Break Mirror" operation to dissolve the RAID logic and revert the healthy disk to a Simple Volume.
4.  **Restoration:** Hot-swapped the replacement drive and manually re-established the mirror relationship ("Add Mirror").
5.  **Outcome:** Resynchronization completed successfully; redundancy restored without data loss or downtime.
