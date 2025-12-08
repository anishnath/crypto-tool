#!/bin/bash
# File Writing in Bash

echo "=== Writing Files in Bash ==="
echo ""

# Method 1: echo with redirection
output_file="/tmp/output.txt"
echo "--- Method 1: echo with > (overwrite) ---"
echo "First line" > "$output_file"
echo "Second line" >> "$output_file"  # Append
echo "File contents:"
cat "$output_file"
echo ""

# Method 2: printf for formatted output
echo "--- Method 2: printf (formatted) ---"
printf "Name: %s\nAge: %d\nScore: %.2f\n" "Alice" 25 98.5 > "$output_file"
echo "Formatted output:"
cat "$output_file"
echo ""

# Method 3: Here document
echo "--- Method 3: Here document ---"
cat > "$output_file" << 'EOF'
[Configuration]
server=localhost
port=8080
debug=true
EOF
echo "Config file:"
cat "$output_file"
echo ""

# Method 4: Multiple lines with echo -e
echo "--- Method 4: echo -e (escape sequences) ---"
echo -e "Line 1\nLine 2\nLine 3\tTabbed" > "$output_file"
cat "$output_file"
echo ""

# Method 5: Command output to file
echo "--- Method 5: Command output ---"
date > "$output_file"
echo "Current date saved:"
cat "$output_file"

# Cleanup
rm -f "$output_file"
