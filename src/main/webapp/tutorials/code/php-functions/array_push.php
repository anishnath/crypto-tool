<?php
// Add elements to end of array
$fruits = ["apple", "banana"];
array_push($fruits, "cherry");
print_r($fruits);  // ["apple", "banana", "cherry"]

// Add multiple elements
array_push($fruits, "date", "elderberry");
print_r($fruits);

// Shorthand (faster)
$fruits[] = "fig";
print_r($fruits);
?>
