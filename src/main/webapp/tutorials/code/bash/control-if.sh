#!/bin/bash
# If Statements in Bash

echo "=========================================="
echo "If Statements Basics"
echo "=========================================="
echo ""

# Basic if statement
age=18
if [ $age -ge 18 ]; then
    echo "You are an adult"
fi
echo ""

# if-else statement
age=15
if [ $age -ge 18 ]; then
    echo "You are an adult"
else
    echo "You are a minor"
fi
echo ""

# if-elif-else statement
score=85
if [ $score -ge 90 ]; then
    grade="A"
elif [ $score -ge 80 ]; then
    grade="B"
elif [ $score -ge 70 ]; then
    grade="C"
else
    grade="F"
fi
echo "Score: $score, Grade: $grade"
echo ""

# Single line if
[ -f /etc/passwd ] && echo "File exists" || echo "File does not exist"
echo ""

# Nested if
age=25
if [ $age -ge 18 ]; then
    echo "Adult"
    if [ $age -ge 65 ]; then
        echo "Senior citizen"
    else
        echo "Regular adult"
    fi
fi
echo ""

echo "=========================================="
echo "If statements use [ ] or [[ ]] for conditions"
echo "=========================================="

