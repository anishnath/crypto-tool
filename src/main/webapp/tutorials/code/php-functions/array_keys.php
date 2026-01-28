<?php
// Get all keys
$person = ["name" => "John", "age" => 25, "city" => "NYC"];
$keys = array_keys($person);
print_r($keys);  // ["name", "age", "city"]

// Keys from indexed array
$fruits = ["apple", "banana", "cherry"];
print_r(array_keys($fruits));  // [0, 1, 2]

// Find keys with specific value
$scores = ["John" => 85, "Jane" => 90, "Bob" => 85];
$keys = array_keys($scores, 85);
print_r($keys);  // ["John", "Bob"]
?>
