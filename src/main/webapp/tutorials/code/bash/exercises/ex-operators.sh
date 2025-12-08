#!/bin/bash
# Exercise: Bash Operators Practice
# Complete the exercises below to test your knowledge!

echo "=== Bash Operators Exercise ==="
echo ""

# Exercise 1: Arithmetic
# Calculate the area of a rectangle with width=12 and height=8
# Store the result in 'area' and print it
echo "--- Exercise 1: Arithmetic ---"
width=12
height=8
# TODO: Calculate area using $(( ))
area=0  # Replace with your calculation
echo "Rectangle area: $area (expected: 96)"
echo ""

# Exercise 2: Comparison
# Check if a score qualifies for different grades
# A: 90+, B: 80-89, C: 70-79, D: 60-69, F: below 60
echo "--- Exercise 2: Comparison ---"
score=85
# TODO: Determine the grade using comparisons
grade="?"  # Replace with your logic
echo "Score $score = Grade $grade (expected: B)"
echo ""

# Exercise 3: Logical Operators
# Check if a user can access a premium feature
# Requirements: must be logged_in AND (subscriber OR admin)
echo "--- Exercise 3: Logical Operators ---"
logged_in=true
subscriber=false
admin=true
# TODO: Determine access using && and ||
has_access=false  # Replace with your logic
echo "Has premium access: $has_access (expected: true)"
echo ""

# Exercise 4: File Tests
# Check various properties of /etc/passwd
echo "--- Exercise 4: File Tests ---"
target_file="/etc/passwd"
# TODO: Complete each test
echo "File: $target_file"
# Test if it exists
# Test if it's readable
# Test if it's a regular file (not directory)
echo "(Complete the tests above)"
echo ""

# Exercise 5: Combined Challenge
# Create a script that validates a configuration file path
# - Must not be empty
# - Must exist
# - Must be a regular file
# - Must be readable
# - Must not be empty (size > 0)
echo "--- Exercise 5: Combined Challenge ---"
config="/etc/hosts"
echo "Validating: $config"
# TODO: Implement all checks and print VALID or INVALID
echo ""

echo "=== End of Exercise ==="
