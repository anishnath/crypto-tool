<?php
// PHP Functional Array Processing - Advanced Examples
// 8gwifi.org/tutorials

echo "=== Real-World: Processing API Data ===\n";

$apiResponse = [
    ["id" => 1, "name" => "Widget A", "price" => 29.99, "stock" => 100],
    ["id" => 2, "name" => "Widget B", "price" => 49.99, "stock" => 0],
    ["id" => 3, "name" => "Widget C", "price" => 19.99, "stock" => 50],
    ["id" => 4, "name" => "Widget D", "price" => 99.99, "stock" => 25]
];

// Get in-stock items with formatted prices
$available = array_filter($apiResponse, fn($p) => $p["stock"] > 0);
$formatted = array_map(fn($p) => [
    "name" => $p["name"],
    "price" => "$" . number_format($p["price"], 2),
    "available" => $p["stock"] . " units"
], $available);

echo "Available Products:\n";
foreach ($formatted as $product) {
    echo "  {$product['name']}: {$product['price']} ({$product['available']})\n";
}

// Calculate total inventory value
$totalValue = array_reduce($apiResponse, fn($sum, $p) => $sum + ($p["price"] * $p["stock"]), 0);
echo "\nTotal Inventory Value: $" . number_format($totalValue, 2) . "\n";

echo "\n=== array_column - Extract Column ===\n";

$users = [
    ["id" => 1, "name" => "Alice", "email" => "alice@test.com"],
    ["id" => 2, "name" => "Bob", "email" => "bob@test.com"],
    ["id" => 3, "name" => "Carol", "email" => "carol@test.com"]
];

// Get all names
$names = array_column($users, "name");
echo "Names: " . implode(", ", $names) . "\n";

// Get emails indexed by id
$emailsById = array_column($users, "email", "id");
print_r($emailsById);

echo "\n=== array_count_values ===\n";

$votes = ["yes", "no", "yes", "yes", "no", "abstain", "yes"];
$counts = array_count_values($votes);
print_r($counts);

echo "\n=== Grouping Data ===\n";

$orders = [
    ["category" => "Electronics", "amount" => 299],
    ["category" => "Clothing", "amount" => 59],
    ["category" => "Electronics", "amount" => 149],
    ["category" => "Books", "amount" => 29],
    ["category" => "Clothing", "amount" => 89]
];

// Group by category and sum
$byCategory = array_reduce($orders, function($result, $order) {
    $cat = $order["category"];
    if (!isset($result[$cat])) {
        $result[$cat] = 0;
    }
    $result[$cat] += $order["amount"];
    return $result;
}, []);

echo "Sales by Category:\n";
foreach ($byCategory as $category => $total) {
    echo "  $category: \$$total\n";
}

echo "\n=== Pipeline Pattern ===\n";

function pipeline($value, ...$functions) {
    return array_reduce($functions, fn($v, $f) => $f($v), $value);
}

$numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

$result = pipeline(
    $numbers,
    fn($arr) => array_filter($arr, fn($n) => $n % 2 === 0),  // Keep evens
    fn($arr) => array_map(fn($n) => $n * $n, $arr),           // Square them
    fn($arr) => array_sum($arr)                                // Sum
);

echo "Sum of squared evens: $result\n";
?>
