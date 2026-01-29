<?php
// Sort associative array by key (reverse)
$ages = [
    "Alice" => 25,
    "Bob" => 30,
    "Charlie" => 20,
    "David" => 35
];

echo "Original:\n";
print_r($ages);

krsort($ages);
echo "\nAfter krsort():\n";
print_r($ages);

// Numeric keys
$numbers = [3 => "three", 1 => "one", 2 => "two", 4 => "four"];
krsort($numbers);
echo "\nNumeric keys sorted (reverse):\n";
print_r($numbers);
?>