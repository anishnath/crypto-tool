#!/bin/bash
# Pattern Matching and Regex in [[ ]]

echo "=== Pattern Matching in [[ ]] ==="
echo ""

filename="script.sh"
email="user@example.com"
text="Hello World 123"

echo "Variables:"
echo "  filename='$filename'"
echo "  email='$email'"
echo "  text='$text'"
echo ""

echo "--- Glob Pattern Matching (==) ---"
if [[ "$filename" == *.sh ]]; then
    echo "'$filename' matches *.sh pattern"
fi

if [[ "$filename" == script* ]]; then
    echo "'$filename' starts with 'script'"
fi

if [[ "$email" == *@* ]]; then
    echo "'$email' contains @ symbol"
fi
echo ""

echo "--- Regex Matching (=~) ---"
# Check if string contains numbers
if [[ "$text" =~ [0-9]+ ]]; then
    echo "'$text' contains numbers"
    echo "  Matched: ${BASH_REMATCH[0]}"
fi

# Email validation (simple)
if [[ "$email" =~ ^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+$ ]]; then
    echo "'$email' looks like a valid email"
fi

# Extract parts with regex groups
version="v2.5.10"
if [[ "$version" =~ v([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    echo "Version '$version' parsed:"
    echo "  Major: ${BASH_REMATCH[1]}"
    echo "  Minor: ${BASH_REMATCH[2]}"
    echo "  Patch: ${BASH_REMATCH[3]}"
fi
