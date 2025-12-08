#!/bin/bash
# File Manipulation in Bash

echo "=== File Manipulation Commands ==="
echo ""

# Setup test directory
test_dir="/tmp/bash_test"
mkdir -p "$test_dir"
cd "$test_dir"

# Create test files
echo "Content A" > file_a.txt
echo "Content B" > file_b.txt
mkdir -p subdir

echo "Created test environment in: $test_dir"
ls -la
echo ""

# cp - Copy files
echo "--- cp: Copy Files ---"
cp file_a.txt file_a_copy.txt
echo "Copied file_a.txt -> file_a_copy.txt"
cp file_a.txt subdir/
echo "Copied file_a.txt -> subdir/"
cp -r subdir subdir_backup
echo "Copied directory: subdir -> subdir_backup"
ls -la
echo ""

# mv - Move/Rename files
echo "--- mv: Move/Rename Files ---"
mv file_a_copy.txt renamed.txt
echo "Renamed file_a_copy.txt -> renamed.txt"
mv renamed.txt subdir/
echo "Moved renamed.txt -> subdir/"
ls -la subdir/
echo ""

# rm - Remove files
echo "--- rm: Remove Files ---"
rm file_b.txt
echo "Removed file_b.txt"
rm -r subdir_backup
echo "Removed directory: subdir_backup"
ls -la
echo ""

# touch - Create/Update timestamps
echo "--- touch: Create/Update Files ---"
touch newfile.txt
echo "Created empty file: newfile.txt"
touch -t 202301011200 newfile.txt
echo "Set timestamp to Jan 1, 2023 12:00"
ls -la newfile.txt

# Cleanup
cd /
rm -rf "$test_dir"
echo ""
echo "Test environment cleaned up"
