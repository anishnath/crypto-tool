#!/usr/bin/env bash
#
# backup.sh - Simple backup script demonstration
#
# This is a simplified demo version that runs in the tutorial.
# A full production version would have more features.
#

set -euo pipefail

echo "=== Backup Script Demo ==="
echo ""

# Configuration
BACKUP_DIR="/tmp/backup_demo"
SOURCE_DIR="/tmp/backup_source"
RETENTION_DAYS=7

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*" >&2
}

# Cleanup handler
cleanup() {
    rm -rf "$SOURCE_DIR" "$BACKUP_DIR" 2>/dev/null || true
}
trap cleanup EXIT

# Setup demo environment
setup_demo() {
    log "Setting up demo environment..."

    # Create source files
    mkdir -p "$SOURCE_DIR"
    echo "Important data file 1" > "$SOURCE_DIR/data1.txt"
    echo "Important data file 2" > "$SOURCE_DIR/data2.txt"
    echo "Configuration settings" > "$SOURCE_DIR/config.conf"
    mkdir -p "$SOURCE_DIR/subdir"
    echo "Nested file" > "$SOURCE_DIR/subdir/nested.txt"

    # Create backup directory
    mkdir -p "$BACKUP_DIR"

    log "Created source files:"
    find "$SOURCE_DIR" -type f -exec echo "  {}" \;
}

# Create backup
create_backup() {
    local source="$1"
    local dest="$2"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_name="backup_${timestamp}.tar.gz"
    local backup_path="$dest/$backup_name"

    log "Creating backup: $backup_name"

    # Create compressed archive
    tar -czf "$backup_path" -C "$(dirname "$source")" "$(basename "$source")"

    # Verify backup
    if tar -tzf "$backup_path" &>/dev/null; then
        local size=$(du -h "$backup_path" | cut -f1)
        log "Backup created successfully: $backup_name ($size)"
    else
        log_error "Backup verification failed!"
        return 1
    fi

    echo "$backup_path"
}

# List existing backups
list_backups() {
    local backup_dir="$1"

    log "Existing backups in $backup_dir:"

    if [[ -d "$backup_dir" ]]; then
        local count=0
        for backup in "$backup_dir"/backup_*.tar.gz; do
            [[ -f "$backup" ]] || continue
            local size=$(du -h "$backup" | cut -f1)
            local name=$(basename "$backup")
            echo "  - $name ($size)"
            ((count++))
        done

        [[ $count -eq 0 ]] && echo "  (no backups found)"
        echo "  Total: $count backup(s)"
    else
        echo "  (backup directory does not exist)"
    fi
}

# Cleanup old backups
cleanup_old_backups() {
    local backup_dir="$1"
    local keep="$2"

    log "Cleaning up old backups (keeping newest $keep)..."

    local backups=($(ls -1t "$backup_dir"/backup_*.tar.gz 2>/dev/null || true))
    local count=${#backups[@]}

    if [[ $count -gt $keep ]]; then
        local to_delete=$((count - keep))
        log "Removing $to_delete old backup(s)"

        for ((i=keep; i<count; i++)); do
            log "  Deleting: $(basename "${backups[$i]}")"
            rm -f "${backups[$i]}"
        done
    else
        log "No old backups to remove"
    fi
}

# Restore from backup
restore_backup() {
    local backup_file="$1"
    local restore_dir="$2"

    log "Restoring from: $(basename "$backup_file")"
    log "Restoring to: $restore_dir"

    mkdir -p "$restore_dir"
    tar -xzf "$backup_file" -C "$restore_dir"

    log "Restore complete"
    log "Restored files:"
    find "$restore_dir" -type f -exec echo "  {}" \;
}

# Main demo
main() {
    # Setup
    setup_demo
    echo ""

    # Create a backup
    log "--- Creating First Backup ---"
    backup1=$(create_backup "$SOURCE_DIR" "$BACKUP_DIR")
    echo ""

    # Wait a moment and create another backup
    sleep 1
    log "--- Creating Second Backup ---"
    # Modify a file first
    echo "Updated content" >> "$SOURCE_DIR/data1.txt"
    backup2=$(create_backup "$SOURCE_DIR" "$BACKUP_DIR")
    echo ""

    # List backups
    log "--- Listing Backups ---"
    list_backups "$BACKUP_DIR"
    echo ""

    # Demonstrate restore
    log "--- Demonstrating Restore ---"
    restore_dir="/tmp/restored_demo"
    restore_backup "$backup2" "$restore_dir"
    rm -rf "$restore_dir"
    echo ""

    # Cleanup old backups (keep 1)
    log "--- Cleanup Old Backups (keep 1) ---"
    cleanup_old_backups "$BACKUP_DIR" 1
    echo ""

    # Final list
    log "--- Final Backup List ---"
    list_backups "$BACKUP_DIR"

    echo ""
    log "=== Backup Demo Complete ==="
}

main "$@"
