<?php
// array_filter() - Filter array elements using a callback
// Returns only elements that pass the test

// Example 1: Remove falsy values (no callback)
$mixed = ["hello", "", 0, null, "world", false, [], "php"];
echo "Original array:\n";
print_r($mixed);

$filtered = array_filter($mixed);
echo "After array_filter (no callback):\n";
print_r($filtered);

// Example 2: Filter even numbers
$numbers = range(1, 10);
echo "Numbers 1-10: [" . implode(", ", $numbers) . "]\n";

$even = array_filter($numbers, fn($n) => $n % 2 === 0);
echo "Even numbers: [" . implode(", ", $even) . "]\n\n";

// Example 3: Filter by condition
$products = [
    ["name" => "Laptop", "price" => 999],
    ["name" => "Mouse", "price" => 25],
    ["name" => "Keyboard", "price" => 75],
    ["name" => "Monitor", "price" => 300],
    ["name" => "Cable", "price" => 10]
];

$expensive = array_filter($products, fn($p) => $p['price'] > 50);
echo "Products over $50:\n";
foreach ($expensive as $p) {
    echo "  - {$p['name']}: \${$p['price']}\n";
}

// Example 4: Filter by key
echo "\nFiltering by key:\n";
$user = [
    "id" => 123,
    "name" => "John",
    "password" => "secret123",
    "email" => "john@test.com"
];

$safe = array_filter(
    $user,
    fn($key) => $key !== 'password',
    ARRAY_FILTER_USE_KEY
);
echo "User data (without password):\n";
print_r($safe);
