# Project: RAID 0 Implementation & Failure Analysis

**Date:** October 2025

## 1.Project Overview
Configured and stress-tested a software-based RAID 0 (Stripe Set) on a Windows 11 virtual machine. The objective was to demonstrate the trade-off between maximized I/O throughput/capacity and the lack of fault tolerance, specifically documenting the catastrophic data loss resulting from a single-disk failure.

## 2. Infrastructure 
* **Hypervisor:** Oracle VirtualBox
* **OS:** Windows 11 (64-bit)
* **Storage Topology:**
    * **Root Vol:** 60GB Virtual Disk (NTFS)
    * **Array Members:** 2x 10GB Virtual Disks (Dynamic Stripe)
    * **Capacity:** ~20GB Usable (100% Efficiency)

## 3. Implementation 
* **Provisioning:** Initialized raw disks as GPT and converted to **Dynamic Disks** to enable software striping across physical extents.
* **Array Build:** Configured a new striped volume via Windows Disk Management, aggregating both disks into a single logical volume (Drive F:).
* **Validation:** Verified aggregated capacity (20GB) and successful write operations.

## 4. Disaster Recovery Simulation (Destructive Test)
To demonstrate the single point of failure risk, a critical hardware event was simulated by physically detaching `Disk 2` from the virtual SATA controller.
1.  **Status Check:** Upon reboot, the logical volume (F:) was completely absent from the OS.
2.  **Diagnostics:** Disk Management reported the remaining member (Disk 1) as **"Failed."**
3.  **Outcome:** Catastrophic data loss. Because data is striped across blocks on both drives, the loss of one member rendered the entire filesystem unrecoverable.

