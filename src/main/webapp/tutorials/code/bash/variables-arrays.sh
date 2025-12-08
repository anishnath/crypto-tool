#!/bin/bash
# Arrays in Bash

echo "=========================================="
echo "Arrays in Bash"
echo "=========================================="
echo ""

# Declaring arrays
fruits=("apple" "banana" "cherry")
numbers=(1 2 3 4 5)

echo "1. Declaring arrays:"
echo "   fruits=(\"apple\" \"banana\" \"cherry\")"
echo "   numbers=(1 2 3 4 5)"
echo ""

# Accessing array elements
echo "2. Accessing array elements:"
echo "   \${fruits[0]}='${fruits[0]}' (first element, index 0)"
echo "   \${fruits[1]}='${fruits[1]}' (second element)"
echo "   \${fruits[2]}='${fruits[2]}' (third element)"
echo ""

# Accessing all elements
echo "3. Accessing all elements:"
echo "   \${fruits[@]}='${fruits[@]}' (all elements separately)"
echo "   \${fruits[*]}='${fruits[*]}' (all elements as one string)"
echo ""

# Array length
echo "4. Array length:"
echo "   \${#fruits[@]}=${#fruits[@]} (number of elements)"
echo "   \${#fruits[0]}=${#fruits[0]} (length of first element)"
echo ""

# Modifying arrays
fruits[1]="blueberry"
echo "5. Modifying array elements:"
echo "   fruits[1]=\"blueberry\""
echo "   fruits array now: ${fruits[@]}"
echo ""

# Adding elements
fruits+=("date" "elderberry")
echo "6. Adding elements:"
echo "   fruits+=(\"date\" \"elderberry\")"
echo "   fruits array now: ${fruits[@]}"
echo ""

# Iterating through array
echo "7. Iterating through array:"
for fruit in "${fruits[@]}"; do
    echo "   - $fruit"
done
echo ""

# Associative arrays (Bash 4+)
declare -A person
person[name]="Alice"
person[age]=25
person[city]="New York"

echo "8. Associative arrays (key-value pairs):"
echo "   declare -A person"
echo "   person[name]='${person[name]}'"
echo "   person[age]=${person[age]}"
echo "   person[city]='${person[city]}'"
echo ""

# Accessing all keys
echo "9. Associative array keys:"
echo "   Keys: ${!person[@]}"
echo ""

echo "=========================================="
echo "Array Operations:"
echo "- Indexed arrays: array=(item1 item2 item3)"
echo "- Access: \${array[index]}"
echo "- All elements: \${array[@]} or \${array[*]}"
echo "- Length: \${#array[@]}"
echo "- Modify: array[index]=value"
echo "- Add: array+=(new items)"
echo "- Associative: declare -A array"
echo "=========================================="

