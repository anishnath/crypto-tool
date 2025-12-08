#!/bin/bash
# File Test Operators in Bash

echo "=== File Test Operators ==="
echo ""

# Create test files for demonstration
test_file="/tmp/test_file.txt"
test_dir="/tmp/test_dir"
echo "Hello World" > "$test_file"
mkdir -p "$test_dir"

echo "Test file: $test_file"
echo "Test directory: $test_dir"
echo ""

# File existence tests
echo "--- Existence Tests ---"
if [[ -e "$test_file" ]]; then
    echo "-e: '$test_file' exists"
fi

if [[ -f "$test_file" ]]; then
    echo "-f: '$test_file' is a regular file"
fi

if [[ -d "$test_dir" ]]; then
    echo "-d: '$test_dir' is a directory"
fi

if [[ ! -e "/nonexistent" ]]; then
    echo "-e: '/nonexistent' does not exist"
fi
echo ""

# Permission tests
echo "--- Permission Tests ---"
if [[ -r "$test_file" ]]; then
    echo "-r: '$test_file' is readable"
fi

if [[ -w "$test_file" ]]; then
    echo "-w: '$test_file' is writable"
fi

# Make file executable for demo
chmod +x "$test_file"
if [[ -x "$test_file" ]]; then
    echo "-x: '$test_file' is executable"
fi
echo ""

# Size tests
echo "--- Size Tests ---"
if [[ -s "$test_file" ]]; then
    echo "-s: '$test_file' has size > 0"
fi

empty_file="/tmp/empty_file.txt"
touch "$empty_file"
if [[ ! -s "$empty_file" ]]; then
    echo "-s: '$empty_file' is empty (size = 0)"
fi

# Cleanup
rm -f "$test_file" "$empty_file"
rmdir "$test_dir" 2>/dev/null
