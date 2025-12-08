#!/bin/bash
# Finding Files with find Command

echo "=== The find Command ==="
echo ""

# Setup test environment
test_dir="/tmp/find_test"
mkdir -p "$test_dir"/{logs,scripts,data}
touch "$test_dir/file1.txt"
touch "$test_dir/file2.log"
touch "$test_dir/logs/app.log"
touch "$test_dir/logs/error.log"
touch "$test_dir/scripts/backup.sh"
touch "$test_dir/scripts/deploy.sh"
touch "$test_dir/data/data.csv"

echo "Test directory structure:"
find "$test_dir" -type f
echo ""

# Find by name
echo "--- Find by Name ---"
echo "Files ending in .log:"
find "$test_dir" -name "*.log"
echo ""

# Find by type
echo "--- Find by Type ---"
echo "Directories only:"
find "$test_dir" -type d
echo ""

# Find by time
echo "--- Find by Time ---"
# Files modified in last 1 day
touch -d "2 days ago" "$test_dir/file1.txt"
echo "Files modified within 1 day:"
find "$test_dir" -type f -mtime -1
echo ""

# Find with exec
echo "--- Find with -exec ---"
echo "All .sh files with permissions:"
find "$test_dir" -name "*.sh" -exec ls -la {} \;
echo ""

# Find and count
echo "--- Find and Count ---"
count=$(find "$test_dir" -type f | wc -l)
echo "Total files: $count"

# Find by size (create a larger file)
dd if=/dev/zero of="$test_dir/large.bin" bs=1K count=100 2>/dev/null
echo ""
echo "Files larger than 50KB:"
find "$test_dir" -type f -size +50k
echo ""

# Combining conditions
echo "--- Combining Conditions ---"
echo ".log files in logs directory:"
find "$test_dir/logs" -name "*.log" -type f

# Cleanup
rm -rf "$test_dir"
