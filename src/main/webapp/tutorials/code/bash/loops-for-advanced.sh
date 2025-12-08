#!/bin/bash
# Advanced For Loop Techniques

echo "=========================================="
echo "Advanced For Loop Patterns"
echo "=========================================="
echo ""

# Iterating with index
echo "1. Iterating with index:"
arr=("first" "second" "third")
for i in "${!arr[@]}"; do
    echo "  Index $i: ${arr[$i]}"
done
echo ""

# Step size in C-style loop
echo "2. Step size (count by 2):"
for ((i=0; i<=10; i+=2)); do
    echo "  $i"
done
echo ""

# Nested for loops
echo "3. Nested for loops:"
for i in {1..3}; do
    for j in {a..c}; do
        echo "  $i$j"
    done
done
echo ""

# Iterating over files
echo "4. Iterating over files:"
for file in /bin/*; do
    if [ -f "$file" ]; then
        echo "  File: $(basename $file)"
    fi
done | head -5
echo ""

# Conditional iteration
echo "5. Processing with conditions:"
for num in {1..10}; do
    if [ $((num % 2)) -eq 0 ]; then
        echo "  $num is even"
    fi
done
echo ""

# Breaking and continuing
echo "6. Using break and continue:"
for i in {1..10}; do
    if [ $i -eq 5 ]; then
        echo "  Skipping 5"
        continue
    fi
    if [ $i -eq 8 ]; then
        echo "  Breaking at 8"
        break
    fi
    echo "  $i"
done
echo ""

echo "=========================================="
echo "For loops are versatile for iteration tasks"
echo "=========================================="

