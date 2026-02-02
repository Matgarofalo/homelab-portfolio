#!/bin/bash

# ==============================================================================
# AUTOMATED BORG BACKUP (NETWORKED)
# ==============================================================================

export REPO="user@192.168.1.56:/srv/BorgRepo"

export BORG_PASSPHRASE='*******'
# --------------------------------------

LOGFILE=~/borg_backup.log
SERVER_IP="192.168.1.56"

echo "--- Backup started: $(date) ---" >> $LOGFILE

# 1. SAFETY CHECK: IS SERVER UP?
# Ping once (-c 1) with 2s timeout (-W 2) to ensure NAS is online.
# If the server is down, we exit immediately to avoid hanging.
ping -c 1 -W 2 $SERVER_IP > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "ERROR: Backup Server ($SERVER_IP) Unreachable. Aborting." >> $LOGFILE
    exit 1
fi

# 2. CREATE BACKUP (Over SSH)
echo "Starting Backup to NAS..."

# 'nice -n 19': Low CPU priority (prevents system lag)
# 'ionice -c 3': Low Disk priority (prevents hard drive slowing down)
nice -n 19 ionice -c 3 borg create \
    --stats \
    --progress \
    --compression zstd \
    "$REPO"::'{now:%Y-%m-%d_%H:%M}' \
    ~/ \
    --exclude '~/Downloads' \
    --exclude '~/.cache' \
    --exclude '~/.local/share/Trash' \
    --exclude '**/.DS_Store' >> $LOGFILE 2>&1  # <-- RESTORED LOGGING HERE

BACKUP_EXIT_CODE=$?

if [ $BACKUP_EXIT_CODE -eq 0 ]; then
    echo "Backup Success." >> $LOGFILE
else
    echo "Backup FAILED (Code: $BACKUP_EXIT_CODE)" >> $LOGFILE
fi

# 3. PRUNE (Retention Policy)
# Only run this if the backup succeeded.
if [ $BACKUP_EXIT_CODE -eq 0 ]; then
    echo "Pruning old archives..."
    nice -n 19 ionice -c 3 borg prune \
        --list \
        --stats \
        --keep-daily=7 \
        --keep-weekly=4 \
        --keep-monthly=6 \
        "$REPO" >> $LOGFILE 2>&1
fi

echo "--- Backup finished: $(date) ---" >> $LOGFILE
