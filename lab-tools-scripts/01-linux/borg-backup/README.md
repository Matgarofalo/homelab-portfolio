# Borg Backup Script
**Date:** January 2026

## I wanted a fully automated solution to backup my data to my Proxmox Server without thinking about it.

## This is a wrapper for **BorgBackup** deduplication.
1.  **System Safety:** It uses `nice` and `ionice` so the backup runs quietly in the background and the system won't lag while it backs up to the NAS.
2.  **Backup:** Snapshots my `/home` directory (excluding downloads/cache junk) and sends it over SSH to `SRV-PVE-NODE1`.
3.  **Cleanup:** Automatically prunes old backups so the server storage doesn't fill up. It keeps:
    * 7 dailies
    * 4 weeklies
    * 6 monthlies

## How I use it
**Automated:**
The script runs automatically every night at **10:00 PM** via a cron job, catching my laptop when it is awake but idle.

**Manual:**
If I need to force a backup (e.g., before a Fedora upgrade), I just type:
```bash
backup


##  Troubleshooting Case Study: Optimizing Backup Execution Time

**The Problem:** Automated daily backups to the Proxmox NAS were taking over 90 minutes and consuming GBs of unnecessary storage, heavily taxing system resources. 

**The Investigation:** By analyzing the live process logs, I isolated the bottleneck to the local browser `.cache` directory. Browser cache files change constantly, forcing Borg's deduplication engine to re-hash thousands of temporary files every night. I discovered that wrapping paths in single quotes in my bash script prevented the terminal from expanding the tilde (`~`) shortcut, causing Borg's pattern matcher to miss the intended exclusion directory.

**The Solution:** 1. Rewrote the script syntax to use universal wildcards (`*/.cache` instead of `~/.cache`) to ensure the directory was properly bypassed.
2. Retroactively purged the old cache data from the NAS by rewriting the archive index: `borg recreate --stats --exclude '*/.cache' <REPO>`
3. Deleted the orphaned data chunks from the server drive to reclaim storage: `borg compact <REPO>`

**The Result:** Reduced daily backup execution time from 1.5 hours to under 30 seconds, drastically lowering CPU overhead and permanently preventing NAS storage bloat.


**Original**
# Quick Borg Backup Script
**Date:** February 2025

## I wanted a single command I could run to backup my data whenever I plug my 1TB external SSD in.

## This is a wrapper for **BorgBackup** deduplication.
1.  **System Safety:** It uses `nice` and `ionice` so the backup runs quietly in the background. I can keep working and the system won't lag while it writes to the SSD.
2.  **Backup:** Snapshots my `/home` directory (excluding downloads/cache junk).
3.  **Cleanup:** Automatically prunes old backups so the drive doesn't fill up. It keeps:
    * 7 dailies
    * 4 weeklies
    * 6 monthlies

## How I use it
1.  Plug in the Extreme SSD.
2.  Open terminal.
3.  Run `./backup.sh`.
4.  Wait for the "Backup Complete" message.
5.  Unplug.

*Next steps: I eventually want to set this external SSd up as NAS and once I get to that, I'll migrate this to an automated cron job over the network.*
