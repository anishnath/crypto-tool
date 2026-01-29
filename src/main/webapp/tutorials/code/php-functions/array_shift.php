<?php
// Basic usage - remove first element
$fruits = ["apple", "banana", "cherry", "date"];
echo "Original array: ";
print_r($fruits);

$first = array_shift($fruits);
echo "\nRemoved element: " . $first . "\n";
echo "Array after shift: ";
print_r($fruits);

// With numeric keys - keys are re-indexed
$numbers = [10, 20, 30, 40];
echo "\nNumbers: ";
print_r($numbers);

array_shift($numbers);
echo "After shift: ";
print_r($numbers);

// Empty array
$empty = [];
$result = array_shift($empty);
echo "\nShift from empty array: ";
var_dump($result);
?>