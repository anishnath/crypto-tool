#!/bin/bash
# Working with Directories in Bash

echo "=== Directory Operations ==="
echo ""

# Setup test directory structure
base="/tmp/dir_test"
mkdir -p "$base"/{docs,scripts,logs}
touch "$base/docs/readme.txt"
touch "$base/docs/guide.md"
touch "$base/scripts/backup.sh"
touch "$base/scripts/deploy.sh"
touch "$base/logs/app.log"
touch "$base/config.txt"

echo "Test directory structure:"
find "$base" -type f
echo ""

# Basic directory operations
echo "--- Basic Directory Operations ---"
echo "Current directory: $(pwd)"
echo "Home directory: $HOME"
echo ""

# List directory contents
echo "--- Listing Contents ---"
echo "Files in $base:"
ls -la "$base"
echo ""

# Iterate over files in directory
echo "--- Iterating with Glob ---"
for file in "$base"/*; do
    if [[ -f "$file" ]]; then
        echo "File: $(basename "$file")"
    elif [[ -d "$file" ]]; then
        echo "Dir:  $(basename "$file")/"
    fi
done
echo ""

# Count items
echo "--- Counting ---"
file_count=$(find "$base" -type f | wc -l)
dir_count=$(find "$base" -type d | wc -l)
echo "Files: $file_count"
echo "Directories: $dir_count"

# Cleanup
rm -rf "$base"
