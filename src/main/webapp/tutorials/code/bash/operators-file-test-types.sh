#!/bin/bash
# File Type Tests in Bash

echo "=== File Type Tests ==="
echo ""

# Create various file types for testing
regular_file="/tmp/regular.txt"
directory="/tmp/test_directory"
symlink="/tmp/symlink"

echo "Creating test files..."
echo "content" > "$regular_file"
mkdir -p "$directory"
ln -sf "$regular_file" "$symlink"
echo ""

echo "Test files created:"
echo "  Regular file: $regular_file"
echo "  Directory: $directory"
echo "  Symlink: $symlink -> $regular_file"
echo ""

echo "--- File Type Detection ---"

# Regular file
if [[ -f "$regular_file" ]]; then
    echo "-f '$regular_file': Regular file"
fi

# Directory
if [[ -d "$directory" ]]; then
    echo "-d '$directory': Directory"
fi

# Symbolic link
if [[ -L "$symlink" ]]; then
    echo "-L '$symlink': Symbolic link"
fi

# Note: -f follows symlinks, so symlink to file returns true
if [[ -f "$symlink" ]]; then
    echo "-f '$symlink': File (follows symlink)"
fi
echo ""

echo "--- Special File Types ---"
# Block device (typically /dev/sda or similar)
if [[ -b "/dev/null" ]]; then
    echo "-b: /dev/null is NOT a block device"
else
    echo "-b: /dev/null is not a block device (it's character device)"
fi

# Character device
if [[ -c "/dev/null" ]]; then
    echo "-c: /dev/null is a character device"
fi

# Named pipe check (create one for demo)
pipe="/tmp/test_pipe"
mkfifo "$pipe" 2>/dev/null
if [[ -p "$pipe" ]]; then
    echo "-p: '$pipe' is a named pipe (FIFO)"
fi
rm -f "$pipe"

# Cleanup
rm -f "$regular_file" "$symlink"
rmdir "$directory" 2>/dev/null
