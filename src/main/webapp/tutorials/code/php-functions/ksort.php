<?php
// Sort associative array by key
$ages = [
    "Charlie" => 20,
    "Alice" => 25,
    "David" => 35,
    "Bob" => 30
];

echo "Original:\n";
print_r($ages);

ksort($ages);
echo "\nAfter ksort():\n";
print_r($ages);

// Numeric keys
$numbers = [3 => "three", 1 => "one", 4 => "four", 2 => "two"];
ksort($numbers);
echo "\nNumeric keys sorted:\n";
print_r($numbers);
?>