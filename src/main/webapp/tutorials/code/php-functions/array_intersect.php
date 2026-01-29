<?php
// Basic intersection
$array1 = [1, 2, 3, 4, 5];
$array2 = [3, 4, 5, 6, 7];

echo "Array 1: ";
print_r($array1);
echo "Array 2: ";
print_r($array2);

$intersect = array_intersect($array1, $array2);
echo "\nIntersection (common values): ";
print_r($intersect);

// String arrays
$fruits1 = ["apple", "banana", "cherry", "date"];
$fruits2 = ["banana", "date", "elderberry"];
$common_fruits = array_intersect($fruits1, $fruits2);
echo "\nCommon fruits: ";
print_r($common_fruits);

// Multiple arrays
$a = [1, 2, 3, 4, 5];
$b = [2, 3, 4, 6];
$c = [3, 4, 7];
$common = array_intersect($a, $b, $c);
echo "\nCommon in all three: ";
print_r($common);

// Associative arrays (compares values, preserves keys from first)
$data1 = ["a" => 1, "b" => 2, "c" => 3];
$data2 = ["x" => 2, "y" => 3, "z" => 4];
$intersect_assoc = array_intersect($data1, $data2);
echo "\nAssociative intersection: ";
print_r($intersect_assoc);
?>