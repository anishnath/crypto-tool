<?php
// Remove duplicates from array
$numbers = [1, 2, 2, 3, 4, 3, 5, 1];
echo "Original: ";
print_r($numbers);

$unique = array_unique($numbers);
echo "\nUnique values: ";
print_r($unique);

// String array
$fruits = ["apple", "banana", "apple", "cherry", "banana"];
$unique_fruits = array_unique($fruits);
echo "\nUnique fruits: ";
print_r($unique_fruits);

// With SORT_NUMERIC flag
$mixed = ["1", 1, "2", 2, "1"];
$unique_numeric = array_unique($mixed, SORT_NUMERIC);
echo "\nUnique (numeric comparison): ";
print_r($unique_numeric);

// Re-index after unique
$reindexed = array_values(array_unique($numbers));
echo "\nRe-indexed unique: ";
print_r($reindexed);
?>