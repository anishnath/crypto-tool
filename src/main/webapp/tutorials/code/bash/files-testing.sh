#!/bin/bash
# Advanced File Testing in Bash

echo "=== File Testing Techniques ==="
echo ""

# Setup test files
test_dir="/tmp/file_test"
mkdir -p "$test_dir"
echo "test content" > "$test_dir/regular.txt"
mkdir -p "$test_dir/subdir"
ln -sf "$test_dir/regular.txt" "$test_dir/symlink.txt"
touch "$test_dir/empty.txt"

echo "Test environment:"
ls -la "$test_dir"
echo ""

# Comprehensive file tests
echo "--- Comprehensive File Tests ---"
file="$test_dir/regular.txt"
echo "Testing: $file"

[[ -e "$file" ]] && echo "  -e: EXISTS"
[[ -f "$file" ]] && echo "  -f: Is regular file"
[[ -d "$file" ]] || echo "  -d: NOT a directory"
[[ -r "$file" ]] && echo "  -r: Is readable"
[[ -w "$file" ]] && echo "  -w: Is writable"
[[ -s "$file" ]] && echo "  -s: Has content (size > 0)"
echo ""

# Testing empty file
echo "Testing empty file: $test_dir/empty.txt"
[[ -s "$test_dir/empty.txt" ]] || echo "  -s: File is EMPTY (size = 0)"
echo ""

# Testing symlink
echo "Testing symlink: $test_dir/symlink.txt"
[[ -L "$test_dir/symlink.txt" ]] && echo "  -L: Is symbolic link"
[[ -f "$test_dir/symlink.txt" ]] && echo "  -f: Points to regular file"
echo ""

# Testing directory
echo "Testing directory: $test_dir/subdir"
[[ -d "$test_dir/subdir" ]] && echo "  -d: Is directory"
[[ -x "$test_dir/subdir" ]] && echo "  -x: Is accessible (can cd into)"
echo ""

# File comparison
echo "--- File Comparison ---"
sleep 1
touch "$test_dir/newer.txt"
if [[ "$test_dir/newer.txt" -nt "$test_dir/regular.txt" ]]; then
    echo "newer.txt is newer than regular.txt"
fi

# Cleanup
rm -rf "$test_dir"
