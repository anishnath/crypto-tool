<?php
// Add single element to beginning
$fruits = ["banana", "cherry"];
echo "Original: ";
print_r($fruits);

array_unshift($fruits, "apple");
echo "\nAfter unshift: ";
print_r($fruits);

// Add multiple elements
$numbers = [3, 4, 5];
echo "\nNumbers: ";
print_r($numbers);

$count = array_unshift($numbers, 1, 2);
echo "Added " . $count . " elements\n";
echo "Result: ";
print_r($numbers);

// With associative array
$data = ["b" => "two", "c" => "three"];
array_unshift($data, "one");
echo "\nAssociative array: ";
print_r($data);
?>