# Project: Clonezilla Installation for Linux Full System Recovery

**Date:** April 2025

## 1. Project Overview

I wanted to implement an automated and secure backup strategy for my Ubuntu Linux workstation using free and open-source tools. The system protects against both minor file loss and major system failure by combining file-level snapshots with full disk imaging.

## 2. Tools Used

* **BorgBackup (`borg`):** Utilized this command-line tool to  encrypt, deduplicate, and compress backups of  my `/home` directory.
* **Clonezilla Live:** Bootable Linux distribution for creating and restoring full, block-level disk images (bare-metal recovery).
* **Bash Scripting:** To automate the Borg backup and pruning process.
* **External SSD:** Used as the storage destination for both Borg repositories and Clonezilla images.
* **Balena Etcher:** Tool used to create the bootable Clonezilla USB drive.

## 3. Process Overview

**A. File-Level Backup (Borg)**
* **Repository Setup:** Initialized an encrypted repository on the external SSD, with recovery keys exported to secure offsite storage.
* **Automation Logic:** Implemented a custom [bash script](../../lab-tools-scripts/01-linux/borg-backup/backup_template.sh) to execute compressed `zstd` snapshots while enforcing a standard retention policy (7 daily, 4 weekly, 6 monthly) which should not significantly affect the amount of storage on my SSD with the compression/deduplication combination.
* **Resource Management:** Configured execution priorities (`nice`/`ionice`) to ensure background backups do not impact workstation performance.

**B. Clonezilla (Full Disk Image):**

1.  Created a bootable Clonezilla Live USB drive using Balena Etcher.
2.  Booted the workstation from the Clonezilla USB.
3.  Used the `device-image` and `savedisk` modes to create a full image of the internal NVMe SSD (`nvme0n1`).
4.  Saved the compressed image to the external SSD (`sda1`).
5.  Utilized Clonezilla's verification feature to ensure the image was restorable.

## 4. Challenges & Troubleshooting

* **Clonezilla "No Space Left":** Initially failed because the image destination was incorrectly set to the small RAM disk (`/home/partimag`) instead of the external SSD partition (`/dev/sda1`). Resolved by carefully re-selecting the correct destination partition during the wizard.
* **Clonezilla "Must Enter Name":** Failed when the image name step was skipped. Resolved by retrying and accepting the default date-based image name.
* **Ubuntu "Low EFI Space" Warning:** Post-Clonezilla reboot, a warning appeared. Diagnosed using Disk Usage Analyzer, revealing an orphaned Clonezilla image folder on the EFI partition from the failed attempt. Resolved by carefully removing the stray folder using `sudo rm -rf /boot/efi/<foldername>`.

## 5. Outcome

Successfully implemented a dual-backup strategy providing both granular file recovery and full system restore capability, managed primarily through the command line.
