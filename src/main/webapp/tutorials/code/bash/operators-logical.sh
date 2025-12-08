#!/bin/bash
# Logical Operators in Bash

echo "=== Bash Logical Operators ==="
echo ""

# Variables for testing
a=10
b=5
name="admin"
logged_in=true

echo "Variables: a=$a, b=$b, name='$name', logged_in=$logged_in"
echo ""

# AND operator (&&)
echo "--- AND Operator (&&) ---"
if [[ $a -gt 5 && $b -lt 10 ]]; then
    echo "Both conditions true: a>5 AND b<10"
fi

# Inside (( )) for arithmetic
if ((a > 5 && b > 0)); then
    echo "Arithmetic AND: a>5 && b>0"
fi
echo ""

# OR operator (||)
echo "--- OR Operator (||) ---"
if [[ $name == "admin" || $name == "root" ]]; then
    echo "User is admin OR root: name='$name'"
fi

if ((a == 10 || b == 10)); then
    echo "Either a=10 OR b=10"
fi
echo ""

# NOT operator (!)
echo "--- NOT Operator (!) ---"
if [[ ! $name == "guest" ]]; then
    echo "NOT guest: name='$name'"
fi

empty_var=""
if [[ ! -n $empty_var ]]; then
    echo "Variable is empty (NOT non-empty)"
fi
echo ""

# Combining operators
echo "--- Combined Conditions ---"
age=25
has_license=true
if [[ $age -ge 18 && $has_license == true ]]; then
    echo "Can drive: age=$age, has_license=$has_license"
fi
