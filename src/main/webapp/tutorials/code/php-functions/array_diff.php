<?php
// Basic difference
$array1 = [1, 2, 3, 4, 5];
$array2 = [3, 4, 5, 6, 7];

echo "Array 1: ";
print_r($array1);
echo "Array 2: ";
print_r($array2);

$diff = array_diff($array1, $array2);
echo "\nDifference (in array1, not in array2): ";
print_r($diff);

// String arrays
$fruits1 = ["apple", "banana", "cherry", "date"];
$fruits2 = ["banana", "date", "elderberry"];
$unique_fruits = array_diff($fruits1, $fruits2);
echo "\nUnique fruits in array1: ";
print_r($unique_fruits);

// Multiple arrays
$a = [1, 2, 3, 4, 5];
$b = [2, 4];
$c = [5];
$result = array_diff($a, $b, $c);
echo "\nDiff with multiple arrays: ";
print_r($result);

// Associative arrays (compares values only)
$data1 = ["a" => 1, "b" => 2, "c" => 3];
$data2 = ["x" => 2, "y" => 4];
$diff_assoc = array_diff($data1, $data2);
echo "\nAssociative diff: ";
print_r($diff_assoc);
?>