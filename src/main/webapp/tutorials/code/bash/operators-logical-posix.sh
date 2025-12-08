#!/bin/bash
# POSIX-compatible Logical Operators: -a and -o

echo "=== POSIX Operators: -a and -o ==="
echo ""

# Note: -a and -o work inside [ ] but are deprecated
# They're shown here for understanding legacy scripts

a=10
b=5
str="hello"

echo "Variables: a=$a, b=$b, str='$str'"
echo ""

echo "--- Using -a (AND) in [ ] ---"
# -a is AND inside single brackets
if [ $a -gt 5 -a $b -lt 10 ]; then
    echo "[ \$a -gt 5 -a \$b -lt 10 ] = true"
fi

echo ""
echo "--- Using -o (OR) in [ ] ---"
# -o is OR inside single brackets
if [ "$str" = "hello" -o "$str" = "world" ]; then
    echo "[ \$str = 'hello' -o \$str = 'world' ] = true"
fi

echo ""
echo "--- Modern Equivalent (Preferred) ---"
# Prefer [[ ]] with && and ||
if [[ $a -gt 5 && $b -lt 10 ]]; then
    echo "[[ \$a -gt 5 && \$b -lt 10 ]] = true"
fi

if [[ "$str" == "hello" || "$str" == "world" ]]; then
    echo "[[ \$str == 'hello' || \$str == 'world' ]] = true"
fi

echo ""
echo "NOTE: Prefer && and || over -a and -o"
echo "The -a and -o operators are deprecated in [[ ]]"
