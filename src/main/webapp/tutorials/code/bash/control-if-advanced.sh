#!/bin/bash
# Advanced If Statements

echo "=========================================="
echo "Advanced If Statement Techniques"
echo "=========================================="
echo ""

# Using [[ ]] instead of [ ]
name="test.txt"
if [[ -f "$name" && -r "$name" ]]; then
    echo "File exists and is readable"
fi
echo ""

# String comparison with [[ ]]
str1="hello"
str2="world"
if [[ $str1 < $str2 ]]; then
    echo "'$str1' comes before '$str2' alphabetically"
fi
echo ""

# Pattern matching with [[ ]]
filename="script.sh"
if [[ $filename == *.sh ]]; then
    echo "$filename is a shell script"
fi
echo ""

# Regex matching with [[ ]]
email="user@example.com"
if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Valid email format"
fi
echo ""

# Multiple conditions
count=5
if [[ $count -gt 0 && $count -lt 10 ]]; then
    echo "Count is between 1 and 9"
fi
echo ""

# Negation
if ! [ -f /nonexistent ]; then
    echo "File does not exist"
fi
echo ""

echo "=========================================="
echo "[[ ]] is more powerful than [ ]"
echo "- Supports pattern matching"
echo "- Supports regex"
echo "- Safer with variables"
echo "=========================================="

