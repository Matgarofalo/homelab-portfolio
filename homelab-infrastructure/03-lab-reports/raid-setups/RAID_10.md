# Project: RAID 10 Implementation & Recovery (CentOS)

**Date:** October 2025

## 1. Executive Summary
Designed and implemented a software-based RAID 10 (Striped Mirror) array on a CentOS Stream 9 virtual machine. The objective was to validate the performance benefits of striping combined with the redundancy of mirroring, specifically testing the array's ability to maintain data integrity during a physical drive failure.

## 2. Infrastructure Specs
* **Hypervisor:** VMware Workstation Player
* **OS:** CentOS Stream 9
* **Storage Topology:**
    * **Root Vol:** 40GB NVMe
    * **Drives:** 4x 10GB NVMe Virtual Disks (RAID 10)
    * **Spare:** 1x 10GB NVMe (Hot Swap)

## 3. Implementation Log
* **Sanitization:** Cleared previous RAID 5 metadata and filesystem signatures from physical volumes to ensure a clean build environment.
* **Array Build:** Configured `/dev/md0` using `mdadm` with a 4-disk layout (Level 10).
* **Filesystem:** Applied **XFS** formatting for high-performance scalability and configured persistent mounting via `/etc/fstab` and `/etc/mdadm.conf`.

## 4. Disaster Recovery Simulation
To verify redundancy, a catastrophic drive failure was simulated by physically detaching `nvme0n2` from the VM while the array was active.
*  **Status Check:** `mdadm --detail` confirmed the array entered a **"Clean, Degraded"** state.
*  **Integrity Verification:** Test data remained 100% accessible via the mount point despite the missing member.
*  **Restoration:** Hot-swapped a replacement virtual disk. The array automatically initiated a rebuild, mirroring data from the surviving stripe partner.
*  **Outcome:** Full redundancy was restored with zero downtime or data loss.

