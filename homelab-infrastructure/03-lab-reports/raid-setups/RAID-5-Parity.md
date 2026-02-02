# Project: RAID 5 Implementation & Recovery (CentOS)

**Date:** October 2025

## 1. Project Overview
Designed and implemented a software-based RAID 5 (Distributed Parity) array on a CentOS Stream 9 virtual machine. The objective was to configure a storage volume that balances storage efficiency with fault tolerance, specifically verifying the array's ability to rebuild data from parity bits after a single drive failure.

## 2. Infrastructure 
* **Hypervisor:** VMware Workstation Player
* **OS:** CentOS Stream 9
* **Storage Topology:**
    * **Root Vol:** 40GB NVMe
    * **Array Members:** 3x 10GB NVMe Virtual Disks (RAID 5)
    * **Capacity:** ~20GB Usable (N-1 Parity Overhead)

## 3. Implementation 
* **Sanitization:**  Formatted the physical volumes to remove residual RAID data and prepare the drives for this configuration.
* **Array Build:** Configured `/dev/md0` using `mdadm` with a 3-disk layout.
* **Filesystem:** Applied **XFS** formatting and configured persistent mounting via `/etc/fstab` and `/etc/mdadm.conf` to ensure boot reliability.

## 4. Disaster Recovery Simulation
To validate the distributed parity mechanism, a drive failure was simulated by physically detaching a member disk from the VM.
*  **Status Check:** `mdadm --detail` confirmed the array entered a **"Clean, Degraded"** state.
*  **Integrity Verification:** Data remained accessible despite the missing member, confirming the immediate failover capability of the parity logic.
*  **Restoration:** Provisioned a "Hot Spare" drive to the pool. The array automatically detected the new volume and initiated a parity rebuild.
*  **Outcome:** The array status transitioned from "Recovering" to "Clean" upon completion of the rebuild.

