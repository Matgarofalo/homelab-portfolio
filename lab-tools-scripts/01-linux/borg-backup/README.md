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
