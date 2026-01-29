<?php
// Basic slice - get middle elements
$fruits = ["apple", "banana", "cherry", "date", "elderberry"];
echo "Original: ";
print_r($fruits);

$slice = array_slice($fruits, 1, 3);
echo "\nSlice [1, 3]: ";
print_r($slice);

// Negative offset - from end
$slice2 = array_slice($fruits, -2);
echo "\nLast 2 elements: ";
print_r($slice2);

// Preserve keys
$data = ["a" => 1, "b" => 2, "c" => 3, "d" => 4];
$preserved = array_slice($data, 1, 2, true);
echo "\nWith preserved keys: ";
print_r($preserved);

// No length - to end
$rest = array_slice($fruits, 2);
echo "\nFrom index 2 to end: ";
print_r($rest);
?>