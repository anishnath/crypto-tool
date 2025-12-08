#!/bin/bash
# Arithmetic Operations in Bash

echo "=== Bash Arithmetic Operations ==="
echo ""

# Basic arithmetic with $((...))
a=10
b=3
echo "Variables: a=$a, b=$b"
echo ""

echo "--- Arithmetic Expansion \$((...)) ---"
echo "Addition: \$((a + b)) = $((a + b))"
echo "Subtraction: \$((a - b)) = $((a - b))"
echo "Multiplication: \$((a * b)) = $((a * b))"
echo "Division: \$((a / b)) = $((a / b))"
echo "Modulus: \$((a % b)) = $((a % b))"
echo "Exponentiation: \$((a ** 2)) = $((a ** 2))"
echo ""

# Compound expressions
echo "--- Compound Expressions ---"
result=$((a + b * 2))
echo "a + b * 2 = $result (multiplication first)"
result=$(((a + b) * 2))
echo "(a + b) * 2 = $result (parentheses first)"
echo ""

# Increment and decrement
echo "--- Increment/Decrement ---"
x=5
echo "Starting x=$x"
((x++))
echo "After x++: x=$x"
((x--))
echo "After x--: x=$x"
((x+=10))
echo "After x+=10: x=$x"
((x*=2))
echo "After x*=2: x=$x"
