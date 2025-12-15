<?php
// Array Searching and Sorting

$numbers = [3, 1, 4, 1, 5, 9, 2, 6];

// Search
echo "Index of 5: " . array_search(5, $numbers);
echo "\n";

// Check if value exists
var_dump(in_array(4, $numbers));  // true
echo "\n";

// Check if key exists
$person = ["name" => "John", "age" => 30];
var_dump(array_key_exists("name", $person));  // true
echo "\n";

// Sort ascending
sort($numbers);
print_r($numbers);
echo "\n";

// Sort descending
rsort($numbers);
print_r($numbers);
echo "\n";

// Sort associative array by value
asort($person);
print_r($person);
echo "\n";

// Sort associative array by key
ksort($person);
print_r($person);
