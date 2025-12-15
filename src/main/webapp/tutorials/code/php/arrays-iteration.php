<?php
// PHP Array Iteration - Functional Style
// 8gwifi.org/tutorials

echo "=== array_map - Transform Each Element ===\n";

$numbers = [1, 2, 3, 4, 5];

// Square each number
$squared = array_map(fn($n) => $n * $n, $numbers);
echo "Squared: " . implode(", ", $squared) . "\n";

// Format prices
$prices = [10, 25.5, 99.99, 5];
$formatted = array_map(fn($p) => "$" . number_format($p, 2), $prices);
echo "Formatted: " . implode(", ", $formatted) . "\n";

// Multiple arrays
$first = ["John", "Jane", "Bob"];
$last = ["Doe", "Smith", "Wilson"];
$full = array_map(fn($f, $l) => "$f $l", $first, $last);
echo "Full names: " . implode(", ", $full) . "\n";

echo "\n=== array_filter - Keep Matching Elements ===\n";

$numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

// Keep even numbers
$evens = array_filter($numbers, fn($n) => $n % 2 === 0);
echo "Evens: " . implode(", ", $evens) . "\n";

// Keep values > 5
$large = array_filter($numbers, fn($n) => $n > 5);
echo "Greater than 5: " . implode(", ", $large) . "\n";

// Filter with keys (ARRAY_FILTER_USE_KEY)
$data = ["name" => "John", "age" => 30, "email" => "john@test.com", "phone" => "555-1234"];
$public = array_filter($data, fn($key) => $key !== "phone", ARRAY_FILTER_USE_KEY);
echo "Public data: ";
print_r($public);

// Remove falsy values (no callback)
$mixed = [0, 1, "", "hello", null, [], true, false];
$truthy = array_filter($mixed);
echo "Truthy only: ";
print_r($truthy);

echo "\n=== array_reduce - Combine to Single Value ===\n";

$numbers = [1, 2, 3, 4, 5];

// Sum
$sum = array_reduce($numbers, fn($carry, $n) => $carry + $n, 0);
echo "Sum: $sum\n";

// Product
$product = array_reduce($numbers, fn($carry, $n) => $carry * $n, 1);
echo "Product: $product\n";

// Find max
$max = array_reduce($numbers, fn($carry, $n) => max($carry, $n), PHP_INT_MIN);
echo "Max: $max\n";

// Concatenate with separator
$words = ["Hello", "World", "PHP"];
$sentence = array_reduce($words, fn($carry, $w) => $carry ? "$carry $w" : $w, "");
echo "Sentence: $sentence\n";

echo "\n=== array_walk - Modify In Place ===\n";

$prices = [10.5, 20.0, 15.75];
echo "Original: " . implode(", ", $prices) . "\n";

// Apply 10% discount in place
array_walk($prices, function(&$price) {
    $price *= 0.9;
});
echo "After 10% off: " . implode(", ", array_map(fn($p) => number_format($p, 2), $prices)) . "\n";

echo "\n=== Chaining Operations ===\n";

$users = [
    ["name" => "Alice", "age" => 25, "active" => true],
    ["name" => "Bob", "age" => 17, "active" => true],
    ["name" => "Carol", "age" => 30, "active" => false],
    ["name" => "David", "age" => 22, "active" => true]
];

// Get names of active adult users
$result = array_map(
    fn($u) => $u["name"],
    array_filter($users, fn($u) => $u["active"] && $u["age"] >= 18)
);
echo "Active adults: " . implode(", ", $result) . "\n";
?>
