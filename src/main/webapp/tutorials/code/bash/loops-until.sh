#!/bin/bash
# Until Loops in Bash

echo "=========================================="
echo "Until Loops"
echo "=========================================="
echo ""

# Basic until loop
count=1
echo "1. Basic until loop (opposite of while):"
until [ $count -gt 5 ]; do
    echo "  Count: $count"
    count=$((count + 1))
done
echo ""

# Until vs While comparison
echo "2. Until continues until condition becomes true:"
num=5
until [ $num -eq 0 ]; do
    echo "  Countdown: $num"
    num=$((num - 1))
done
echo "  Blast off!"
echo ""

# Until with file check (simulated)
echo "3. Until a condition is met:"
counter=0
until [ $counter -ge 3 ]; do
    echo "  Attempt: $counter"
    counter=$((counter + 1))
done
echo "  Condition met!"
echo ""

# Until loop is useful when you want to continue
# UNTIL something becomes true (opposite of while)
echo "=========================================="
echo "Until loops continue UNTIL condition is true"
echo "While loops continue WHILE condition is true"
echo "=========================================="

