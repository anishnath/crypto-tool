#!/bin/bash
# File Reading in Bash

echo "=== Reading Files in Bash ==="
echo ""

# Create a sample file for demonstration
sample_file="/tmp/sample.txt"
cat > "$sample_file" << 'EOF'
Line 1: Hello World
Line 2: Bash is powerful
Line 3: File operations are essential
Line 4: Learning is fun
Line 5: The end
EOF

echo "Sample file created: $sample_file"
echo "Contents:"
cat "$sample_file"
echo ""

# Method 1: cat - Read entire file
echo "--- Method 1: cat (entire file) ---"
content=$(cat "$sample_file")
echo "Variable contains:"
echo "$content"
echo ""

# Method 2: while read loop - Line by line
echo "--- Method 2: while read (line by line) ---"
line_num=0
while IFS= read -r line; do
    ((line_num++))
    echo "  Line $line_num: $line"
done < "$sample_file"
echo ""

# Method 3: Reading into array
echo "--- Method 3: readarray/mapfile (into array) ---"
mapfile -t lines < "$sample_file"
echo "Array has ${#lines[@]} elements"
echo "First line: ${lines[0]}"
echo "Last line: ${lines[-1]}"

# Cleanup
rm -f "$sample_file"
