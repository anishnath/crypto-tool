<?php
// Array Operators

$arr1 = ["a" => "apple", "b" => "banana"];
$arr2 = ["b" => "blueberry", "c" => "cherry"];

// Union (combines arrays, keeps first values for duplicate keys)
$union = $arr1 + $arr2;
print_r($union);
// ["a" => "apple", "b" => "banana", "c" => "cherry"]
echo "\n";

// Equality (same key-value pairs, any order)
$a = ["x" => 1, "y" => 2];
$b = ["y" => 2, "x" => 1];
var_dump($a == $b);  // true
echo "\n";

// Identity (same key-value pairs, same order, same types)
var_dump($a === $b);  // false (different order)
echo "\n";

// Inequality
var_dump($arr1 != $arr2);  // true
var_dump($arr1 <> $arr2);  // true
echo "\n";

// Non-identity
var_dump($arr1 !== $arr2);  // true
