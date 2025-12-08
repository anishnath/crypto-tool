#!/bin/bash
# File Comparison Tests in Bash

echo "=== File Comparison Tests ==="
echo ""

# Create test files
file1="/tmp/file1.txt"
file2="/tmp/file2.txt"
file3="/tmp/file3.txt"

echo "Creating test files..."
echo "content" > "$file1"
sleep 1  # Ensure different timestamps
echo "content" > "$file2"
echo "different" > "$file3"

# Create a hard link (same inode)
hardlink="/tmp/hardlink.txt"
ln "$file1" "$hardlink"
echo ""

echo "Files created:"
echo "  file1: $file1"
echo "  file2: $file2 (created after file1)"
echo "  file3: $file3 (different content)"
echo "  hardlink: $hardlink (hard link to file1)"
echo ""

echo "--- Timestamp Comparisons ---"
# Newer than
if [[ "$file2" -nt "$file1" ]]; then
    echo "-nt: file2 is newer than file1"
fi

# Older than
if [[ "$file1" -ot "$file2" ]]; then
    echo "-ot: file1 is older than file2"
fi
echo ""

echo "--- Identity Test (Same File) ---"
# Same file (by inode)
if [[ "$file1" -ef "$hardlink" ]]; then
    echo "-ef: file1 and hardlink are the same file (same inode)"
fi

if [[ ! "$file1" -ef "$file2" ]]; then
    echo "-ef: file1 and file2 are NOT the same file"
fi
echo ""

echo "--- Practical Example: Backup Check ---"
source_file="$file1"
backup_file="$file2"

if [[ "$source_file" -nt "$backup_file" ]]; then
    echo "Source is newer - backup needed!"
else
    echo "Backup is up to date"
fi

# Cleanup
rm -f "$file1" "$file2" "$file3" "$hardlink"
