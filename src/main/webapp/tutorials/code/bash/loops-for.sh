#!/bin/bash
# For Loops in Bash

echo "=========================================="
echo "For Loops Basics"
echo "=========================================="
echo ""

# For in loop
echo "1. For in loop:"
for item in apple banana cherry; do
    echo "  Fruit: $item"
done
echo ""

# Iterating over array
fruits=("apple" "banana" "cherry")
echo "2. Iterating over array:"
for fruit in "${fruits[@]}"; do
    echo "  $fruit"
done
echo ""

# Iterating over command output
echo "3. Iterating over command output:"
for file in $(ls /bin | head -5); do
    echo "  $file"
done
echo ""

# C-style for loop
echo "4. C-style for loop:"
for ((i=1; i<=5; i++)); do
    echo "  Count: $i"
done
echo ""

# For loop with range
echo "5. Using brace expansion:"
for num in {1..5}; do
    echo "  Number: $num"
done
echo ""

# Iterating over arguments
echo "6. Iterating over script arguments:"
for arg in "$@"; do
    echo "  Argument: $arg"
done
echo ""

echo "=========================================="
echo "For loops iterate over lists or use C-style syntax"
echo "=========================================="

