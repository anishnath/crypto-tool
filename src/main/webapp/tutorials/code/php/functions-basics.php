<?php
// Function Basics

// Simple function
function greet()
{
    echo "Hello, World!";
}

greet();  // Call the function
echo "\n";

// Function with parameters
function greetUser($name)
{
    echo "Hello, $name!";
}

greetUser("Alice");
echo "\n";

// Function with return value
function add($a, $b)
{
    return $a + $b;
}

$result = add(5, 3);
echo "5 + 3 = $result";
echo "\n";

// Function with multiple parameters
function calculateArea($width, $height)
{
    return $width * $height;
}

echo "Area: " . calculateArea(10, 5);
