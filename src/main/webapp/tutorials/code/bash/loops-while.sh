#!/bin/bash
# While Loops in Bash

echo "=========================================="
echo "While Loops"
echo "=========================================="
echo ""

# Basic while loop
count=1
echo "1. Basic while loop:"
while [ $count -le 5 ]; do
    echo "  Count: $count"
    count=$((count + 1))
done
echo ""

# Reading file line by line
echo "2. Reading input line by line (simulated):"
echo -e "line1\nline2\nline3" | while read line; do
    echo "  Read: $line"
done
echo ""

# While with user input (simulated)
echo "3. While with condition:"
num=0
while [ $num -lt 3 ]; do
    echo "  Number: $num"
    num=$((num + 1))
done
echo ""

# Infinite loop (with break condition)
echo "4. Controlled infinite loop:"
counter=0
while true; do
    counter=$((counter + 1))
    if [ $counter -gt 3 ]; then
        break
    fi
    echo "  Loop iteration: $counter"
done
echo ""

# While with command condition
echo "5. While with command condition:"
num=0
while [ $num -lt 5 ]; do
    echo "  Processing: $num"
    num=$((num + 1))
done
echo ""

echo "=========================================="
echo "While loops continue while condition is true"
echo "=========================================="

