#!/bin/bash
# Comparison Operators in Bash

echo "=== Bash Comparison Operators ==="
echo ""

# Integer comparisons with (( ))
a=10
b=5
echo "Variables: a=$a, b=$b"
echo ""

echo "--- Integer Comparisons with (( )) ---"
if ((a > b)); then
    echo "a > b: true ($a is greater than $b)"
fi

if ((a >= b)); then
    echo "a >= b: true"
fi

if ((a < b)); then
    echo "a < b: true"
else
    echo "a < b: false ($a is not less than $b)"
fi

if ((a == b)); then
    echo "a == b: true"
else
    echo "a == b: false ($a is not equal to $b)"
fi

if ((a != b)); then
    echo "a != b: true ($a is not equal to $b)"
fi
echo ""

# Integer comparisons with [[ ]] using flags
echo "--- Integer Comparisons with [[ ]] flags ---"
x=20
y=20
echo "Variables: x=$x, y=$y"

if [[ $x -eq $y ]]; then
    echo "-eq: $x equals $y"
fi

if [[ $x -ne 15 ]]; then
    echo "-ne: $x does not equal 15"
fi

if [[ $x -gt 10 ]]; then
    echo "-gt: $x is greater than 10"
fi

if [[ $x -ge 20 ]]; then
    echo "-ge: $x is greater than or equal to 20"
fi
