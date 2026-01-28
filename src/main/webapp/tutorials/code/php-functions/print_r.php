<?php
// Human-readable output
$arr = ["apple", "banana", "cherry"];
print_r($arr);

// Associative array
$user = [
    "name" => "John",
    "age" => 30,
    "city" => "NYC"
];
print_r($user);

// Return as string instead of printing
$output = print_r($arr, true);
echo "The array is: $output";

// For debugging in HTML
echo "<pre>";
print_r($user);
echo "</pre>";
?>
