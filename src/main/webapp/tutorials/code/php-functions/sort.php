<?php
// Sort array (modifies original)
$fruits = ["cherry", "apple", "banana"];
sort($fruits);
print_r($fruits);  // ["apple", "banana", "cherry"]

// Sort numbers
$numbers = [3, 1, 4, 1, 5, 9];
sort($numbers);
print_r($numbers);  // [1, 1, 3, 4, 5, 9]

// Reverse sort
$nums = [3, 1, 4];
rsort($nums);
print_r($nums);  // [4, 3, 1]

// Sort associative (keep keys)
$ages = ["John" => 25, "Jane" => 30, "Bob" => 20];
asort($ages);
print_r($ages);  // Bob=>20, John=>25, Jane=>30
?>
