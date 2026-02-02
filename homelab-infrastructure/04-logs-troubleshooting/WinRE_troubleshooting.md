# Project: WinRE Boot Volume Triage (Diskpart)

**Date:** October 2025

## 1. Projeect Overview
Simulated a no boot scenario to determine why offline repair scripts were failing. The triage taught me that the Recovery Environment shuffles drive letters, hiding the boot partition and renaming the OS drive requiring manual mapping before any repairs can be attempted.

## 2. Infrastructure
* **Target:** Windows 11 Virtual Machine
* **Boot Media:** Windows 11 Installation ISO (Mounted vCD)
* **Toolchain:** Windows Recovery Environment (WinRE) > Command Prompt > `diskpart`

## 3. Diagnostics
1.  **Environment Entry:** Booted VM from ISO media and navigated to **Repair your computer** > **Troubleshoot** > **Command Prompt**.
2.  **Volume Enumeration:** Launched `diskpart` and executed `list volume` to identify the current logical mappings.
3.  **Topology Mapping:**
    * **Volume 0 (E:):** Virtual ODD (Boot Media).
    * **Volume 1 (X:):** WinRE RAM Disk (Temporary scratch space).
    * **Volume 2 (D:):** Primary NTFS OS Partition (Mapped as **C:** in Live OS).
    * **Volume 3 (C:):** EFI System Partition (Hidden in Live OS).

## 4. Analysis & Findings
The triage revealed a critical discrepancy in drive letter assignment between the Live OS and the Recovery Environment.
* **The Shift:** WinRE mounted the usually hidden **EFI Partition** as `C:`, pushing the actual **Windows OS Partition** to `D:`.
* **The Risk:** Executing standard repair scripts (e.g., `sfc /scannow /offbootdir=C:\`) without verification would target the 100MB Boot partition instead of the OS, resulting in a "Resource Protection could not perform the requested operation" error.

