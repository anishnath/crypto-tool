#!/bin/bash
# String Comparison Operators in Bash

echo "=== String Comparisons ==="
echo ""

str1="hello"
str2="world"
str3="hello"
empty=""

echo "Variables:"
echo "  str1='$str1'"
echo "  str2='$str2'"
echo "  str3='$str3'"
echo "  empty='$empty'"
echo ""

echo "--- String Equality ---"
if [[ "$str1" == "$str3" ]]; then
    echo "str1 == str3: true ('$str1' equals '$str3')"
fi

if [[ "$str1" != "$str2" ]]; then
    echo "str1 != str2: true ('$str1' not equal '$str2')"
fi
echo ""

echo "--- String Length Tests ---"
if [[ -z "$empty" ]]; then
    echo "-z empty: true (string is empty/zero length)"
fi

if [[ -n "$str1" ]]; then
    echo "-n str1: true (string is not empty)"
fi
echo ""

echo "--- Lexicographic Comparison ---"
if [[ "$str1" < "$str2" ]]; then
    echo "str1 < str2: true ('$str1' comes before '$str2' alphabetically)"
fi

if [[ "apple" < "banana" ]]; then
    echo "'apple' < 'banana': true (alphabetically)"
fi

if [[ "zebra" > "apple" ]]; then
    echo "'zebra' > 'apple': true (alphabetically)"
fi
