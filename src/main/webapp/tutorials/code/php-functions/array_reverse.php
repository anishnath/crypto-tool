<?php
// Basic reverse
$numbers = [1, 2, 3, 4, 5];
echo "Original: ";
print_r($numbers);

$reversed = array_reverse($numbers);
echo "\nReversed: ";
print_r($reversed);

// String array
$fruits = ["apple", "banana", "cherry"];
$reversed_fruits = array_reverse($fruits);
echo "\nReversed fruits: ";
print_r($reversed_fruits);

// Preserve keys
$data = ["a" => 1, "b" => 2, "c" => 3];
$preserved = array_reverse($data, true);
echo "\nWith preserved keys: ";
print_r($preserved);

// Numeric keys preserved
$items = [10 => "first", 20 => "second", 30 => "third"];
$rev_preserved = array_reverse($items, true);
echo "\nNumeric keys preserved: ";
print_r($rev_preserved);
?>