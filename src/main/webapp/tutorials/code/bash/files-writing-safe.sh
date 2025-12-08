#!/bin/bash
# Safe File Writing Techniques

echo "=== Safe File Writing ==="
echo ""

output_file="/tmp/important.txt"
backup_file="/tmp/important.txt.bak"

# Initial content
echo "Original content" > "$output_file"
echo "Initial file:"
cat "$output_file"
echo ""

# Safe write with backup
echo "--- Safe Write with Backup ---"
if [[ -f "$output_file" ]]; then
    cp "$output_file" "$backup_file"
    echo "Backup created: $backup_file"
fi
echo "New content" > "$output_file"
echo "Updated file:"
cat "$output_file"
echo ""

# Atomic write using temp file
echo "--- Atomic Write (temp file) ---"
temp_file=$(mktemp)
echo "Writing to temp file: $temp_file"
{
    echo "Line 1 of atomic write"
    echo "Line 2 of atomic write"
    echo "Line 3 of atomic write"
} > "$temp_file"

# Only move if write succeeded
if [[ $? -eq 0 ]]; then
    mv "$temp_file" "$output_file"
    echo "Atomically moved to: $output_file"
fi
cat "$output_file"
echo ""

# Write with noclobber (prevent overwrite)
echo "--- Noclobber Prevention ---"
set -o noclobber
echo "test" >| "$output_file"  # >| forces overwrite even with noclobber
echo "Used >| to force write with noclobber"
set +o noclobber
echo ""

# Append with timestamp
echo "--- Append with Timestamp ---"
log_file="/tmp/app.log"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Application started" >> "$log_file"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Processing data..." >> "$log_file"
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Complete" >> "$log_file"
echo "Log file contents:"
cat "$log_file"

# Cleanup
rm -f "$output_file" "$backup_file" "$log_file"
