#!/bin/bash
# Reading Parts of Files

echo "=== Reading Partial File Content ==="
echo ""

# Create a sample file
sample_file="/tmp/numbers.txt"
seq 1 20 > "$sample_file"

echo "Sample file: numbers 1-20"
echo ""

# head - First N lines
echo "--- head: First lines ---"
echo "head -n 5 (first 5 lines):"
head -n 5 "$sample_file"
echo ""

# tail - Last N lines
echo "--- tail: Last lines ---"
echo "tail -n 3 (last 3 lines):"
tail -n 3 "$sample_file"
echo ""

# tail -f simulation (follow mode)
echo "--- tail -f: Follow mode ---"
echo "tail -f watches file for new content (Ctrl+C to stop)"
echo "(Used for log monitoring)"
echo ""

# Specific line range using sed
echo "--- sed: Line range ---"
echo "Lines 5-10:"
sed -n '5,10p' "$sample_file"
echo ""

# Using head + tail for middle section
echo "--- head + tail: Middle section ---"
echo "Lines 8-12 (head -12 | tail -5):"
head -12 "$sample_file" | tail -5
echo ""

# Skip first N lines
echo "--- tail +N: Skip first lines ---"
echo "Skip first 15 lines (tail -n +16):"
tail -n +16 "$sample_file"

# Cleanup
rm -f "$sample_file"
