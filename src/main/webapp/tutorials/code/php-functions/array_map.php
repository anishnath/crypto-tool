<?php
// array_map() - Apply callback to array elements
// Returns a new array with transformed elements

// Example 1: Square numbers
$numbers = [1, 2, 3, 4, 5];
echo "Original: [" . implode(", ", $numbers) . "]\n";

$squared = array_map(fn($n) => $n * $n, $numbers);
echo "Squared:  [" . implode(", ", $squared) . "]\n\n";

// Example 2: Transform strings
$names = ["john", "jane", "bob"];
echo "Names (lowercase): [" . implode(", ", $names) . "]\n";

$capitalized = array_map('ucfirst', $names);
echo "Names (capitalized): [" . implode(", ", $capitalized) . "]\n\n";

// Example 3: Extract from array of arrays
$users = [
    ["name" => "Alice", "age" => 25],
    ["name" => "Bob", "age" => 30],
    ["name" => "Charlie", "age" => 35]
];

$names = array_map(fn($user) => $user['name'], $users);
echo "Extracted names: [" . implode(", ", $names) . "]\n\n";

// Example 4: Multiple arrays
$prices = [10, 20, 30];
$quantities = [2, 3, 1];

$totals = array_map(
    fn($price, $qty) => $price * $qty,
    $prices,
    $quantities
);
echo "Prices:     [" . implode(", ", $prices) . "]\n";
echo "Quantities: [" . implode(", ", $quantities) . "]\n";
echo "Totals:     [" . implode(", ", $totals) . "]\n";
