#!/bin/bash
# Advanced find Operations

echo "=== Advanced find for Directories ==="
echo ""

# Setup test environment
base="/tmp/find_adv"
mkdir -p "$base"/{src,build,docs}
touch "$base/src/main.c"
touch "$base/src/utils.c"
touch "$base/build/main.o"
touch "$base/build/app"
touch "$base/docs/readme.md"

# Create some varied files
echo "old content" > "$base/old.txt"
touch -d "30 days ago" "$base/old.txt"
dd if=/dev/zero of="$base/large.bin" bs=1K count=500 2>/dev/null

echo "Test structure created"
echo ""

# Find and delete empty directories
echo "--- Find Empty Directories ---"
mkdir -p "$base/empty_dir"
find "$base" -type d -empty -print
echo ""

# Find by multiple extensions
echo "--- Find Multiple Extensions ---"
find "$base" \( -name "*.c" -o -name "*.md" \) -type f
echo ""

# Find and execute with multiple commands
echo "--- Find with Actions ---"
echo "Files with sizes:"
find "$base" -type f -exec ls -lh {} \; | awk '{print $9, $5}'
echo ""

# Find excluding directories
echo "--- Find Excluding Paths ---"
echo "All files except in build/:"
find "$base" -path "$base/build" -prune -o -type f -print
echo ""

# Find by size ranges
echo "--- Find by Size ---"
echo "Files between 100KB and 1MB:"
find "$base" -type f -size +100k -size -1M
echo ""

# Find modified files
echo "--- Find by Time ---"
echo "Files modified more than 7 days ago:"
find "$base" -type f -mtime +7
echo ""

# Find and transform
echo "--- Find and Process ---"
echo "Source files with line counts:"
find "$base/src" -name "*.c" -exec wc -l {} \;

# Cleanup
rm -rf "$base"
