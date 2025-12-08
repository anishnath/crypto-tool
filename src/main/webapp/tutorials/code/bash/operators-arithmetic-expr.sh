#!/bin/bash
# Using 'expr' for arithmetic (legacy method)

echo "=== The 'expr' Command (Legacy) ==="
echo ""

# Basic expr usage
a=10
b=4
echo "Variables: a=$a, b=$b"
echo ""

# Note: spaces are required around operators!
echo "--- Basic Operations ---"
result=$(expr $a + $b)
echo "expr \$a + \$b = $result"

result=$(expr $a - $b)
echo "expr \$a - \$b = $result"

# Multiplication needs escaping
result=$(expr $a \* $b)
echo "expr \$a \\* \$b = $result"

result=$(expr $a / $b)
echo "expr \$a / \$b = $result"

result=$(expr $a % $b)
echo "expr \$a % \$b = $result"
echo ""

# String length with expr
text="Hello Bash"
length=$(expr length "$text")
echo "--- String Operations ---"
echo "Text: '$text'"
echo "Length: $length"
