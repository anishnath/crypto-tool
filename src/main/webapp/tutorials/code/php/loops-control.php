<?php
// PHP Loop Control Demo
// 8gwifi.org/tutorials

echo "=== Break: Exit Loop Early ===\n";
$numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

echo "Finding first number > 5: ";
foreach ($numbers as $num) {
    if ($num > 5) {
        echo "Found $num!\n";
        break;  // Exit loop immediately
    }
    echo "$num, ";
}

echo "\n=== Continue: Skip Iteration ===\n";
echo "Odd numbers only: ";
for ($i = 1; $i <= 10; $i++) {
    if ($i % 2 === 0) {
        continue;  // Skip even numbers
    }
    echo "$i ";
}
echo "\n";

echo "\n=== Break in While Loop ===\n";
$count = 0;
while (true) {  // Infinite loop
    $count++;
    echo "Iteration $count\n";

    if ($count >= 3) {
        echo "Breaking out!\n";
        break;
    }
}

echo "\n=== Continue in While Loop ===\n";
$i = 0;
echo "Skip multiples of 3: ";
while ($i < 10) {
    $i++;
    if ($i % 3 === 0) {
        continue;  // Skip this iteration
    }
    echo "$i ";
}
echo "\n";

echo "\n=== Practical: Search and Stop ===\n";
$users = [
    ["id" => 1, "name" => "Alice"],
    ["id" => 2, "name" => "Bob"],
    ["id" => 3, "name" => "Carol"],
    ["id" => 4, "name" => "David"]
];

$searchId = 2;
$found = null;

foreach ($users as $user) {
    if ($user['id'] === $searchId) {
        $found = $user;
        break;  // Stop searching once found
    }
}

if ($found) {
    echo "Found user: {$found['name']} (ID: {$found['id']})\n";
} else {
    echo "User not found\n";
}

echo "\n=== Practical: Filter with Continue ===\n";
$products = [
    ["name" => "Laptop", "price" => 999, "inStock" => true],
    ["name" => "Mouse", "price" => 29, "inStock" => false],
    ["name" => "Keyboard", "price" => 79, "inStock" => true],
    ["name" => "Monitor", "price" => 299, "inStock" => false]
];

echo "In-stock items:\n";
foreach ($products as $product) {
    if (!$product['inStock']) {
        continue;  // Skip out-of-stock items
    }
    echo "  - {$product['name']}: \${$product['price']}\n";
}
?>
