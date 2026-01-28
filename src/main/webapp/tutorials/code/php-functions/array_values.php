<?php
// Get all values (reindex array)
$person = ["name" => "John", "age" => 25];
$values = array_values($person);
print_r($values);  // ["John", 25]

// Reindex after filter
$numbers = [0 => "a", 2 => "b", 5 => "c"];
$reindexed = array_values($numbers);
print_r($reindexed);  // [0 => "a", 1 => "b", 2 => "c"]

// Common: reindex filtered array
$data = [1, 2, 3, 4, 5];
$even = array_values(array_filter($data, fn($n) => $n % 2 === 0));
print_r($even);  // [0 => 2, 1 => 4]
?>
