#!/bin/bash
# Using 'bc' for floating-point arithmetic

echo "=== Floating-Point with 'bc' ==="
echo ""

# bc is the basic calculator for decimals
a=10
b=3
echo "Variables: a=$a, b=$b"
echo ""

echo "--- Integer Division vs bc ---"
int_div=$((a / b))
echo "Integer division \$((a / b)) = $int_div"

float_div=$(echo "scale=2; $a / $b" | bc)
echo "bc with scale=2: $float_div"
echo ""

# Various calculations with bc
echo "--- bc Calculations ---"
result=$(echo "scale=4; 22 / 7" | bc)
echo "Pi approximation (22/7): $result"

result=$(echo "scale=2; sqrt(2)" | bc)
echo "Square root of 2: $result"

result=$(echo "scale=3; 2.5 * 3.7" | bc)
echo "2.5 * 3.7 = $result"

result=$(echo "scale=2; (100 - 75) / 100 * 100" | bc)
echo "Percentage: 75 out of 100 = ${result}%"
echo ""

# Practical example: temperature conversion
fahrenheit=98.6
celsius=$(echo "scale=2; ($fahrenheit - 32) * 5 / 9" | bc)
echo "--- Temperature Conversion ---"
echo "$fahrenheit°F = $celsius°C"
