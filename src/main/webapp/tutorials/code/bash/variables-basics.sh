#!/bin/bash
# Variables Basics in Bash

echo "=========================================="
echo "Bash Variables Basics"
echo "=========================================="
echo ""

# Variable assignment (no spaces around =)
name="Alice"
age=25
city="New York"

echo "1. Basic variable assignment:"
echo "   name=\"Alice\""
echo "   age=25"
echo "   city=\"New York\""
echo ""

# Accessing variables with $
echo "2. Accessing variables with \$:"
echo "   Name: $name"
echo "   Age: $age"
echo "   City: $city"
echo ""

# Variable names are case-sensitive
Name="Bob"
echo "3. Case-sensitive variable names:"
echo "   name='$name' (lowercase)"
echo "   Name='$Name' (uppercase N) - different variable!"
echo ""

# Reassigning variables
age=26
echo "4. Reassigning variables:"
echo "   Age changed from 25 to $age"
echo ""

# Using variables in strings
echo "5. Using variables in strings:"
echo "   Hello, my name is $name and I am $age years old."
echo "   I live in $city."
echo ""

# Unsetting variables
unset age
echo "6. Unsetting variables (unset age):"
echo "   Age after unset: '${age:-undefined}'"
echo ""

echo "=========================================="
echo "Key Rules:"
echo "- No spaces around = in assignment"
echo "- Use \$ to access variable values"
echo "- Variable names are case-sensitive"
echo "- Use unset to remove variables"
echo "=========================================="

