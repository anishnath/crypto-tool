<?php
// Count array elements
$fruits = ["apple", "banana", "cherry"];
echo "Fruits count: " . count($fruits) . "\n";

// Count multidimensional array
$matrix = [[1, 2], [3, 4], [5, 6]];
echo "Matrix count (normal): " . count($matrix) . "\n";
echo "Matrix count (recursive): " . count($matrix, COUNT_RECURSIVE) . "\n";

// Empty array
$empty = [];
echo "Empty array count: " . count($empty) . "\n";

// Associative array
$person = ["name" => "John", "age" => 30, "city" => "NYC"];
echo "Person properties: " . count($person);
?>