<?php
// Arrow Functions (PHP 7.4+)

// Traditional anonymous function
$multiply = function ($x, $y) {
    return $x * $y;
};

echo $multiply(5, 3);  // 15
echo "\n";

// Arrow function - shorter syntax
$multiplyArrow = fn($x, $y) => $x * $y;

echo $multiplyArrow(5, 3);  // 15
echo "\n";

// Arrow functions with array operations
$numbers = [1, 2, 3, 4, 5];

// Map with arrow function
$squared = array_map(fn($n) => $n * $n, $numbers);
print_r($squared);

// Filter with arrow function
$evens = array_filter($numbers, fn($n) => $n % 2 === 0);
print_r($evens);

// Arrow function automatically captures variables
$factor = 10;
$scaled = array_map(fn($n) => $n * $factor, $numbers);
print_r($scaled);
