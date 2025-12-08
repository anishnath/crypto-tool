#!/bin/bash
# Using 'let' for arithmetic

echo "=== The 'let' Command ==="
echo ""

# Basic let usage
let a=5
let b=3
echo "let a=5  -> a=$a"
echo "let b=3  -> b=$b"
echo ""

# Arithmetic with let
let c=a+b
echo "let c=a+b  -> c=$c"

let d=a*b
echo "let d=a*b  -> d=$d"

let e=a**2
echo "let e=a**2  -> e=$e"
echo ""

# Multiple operations
let "x = 10" "y = x + 5"
echo "let \"x = 10\" \"y = x + 5\""
echo "x=$x, y=$y"
echo ""

# Increment/decrement with let
counter=0
echo "Starting counter=$counter"
let counter++
echo "After let counter++: $counter"
let counter+=5
echo "After let counter+=5: $counter"
let counter--
echo "After let counter--: $counter"
