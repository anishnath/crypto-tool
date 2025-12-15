<?php
// PHP Foreach Reference Modification Demo
// 8gwifi.org/tutorials

echo "=== Modifying Values by Reference ===\n";
$prices = [10.50, 20.00, 15.75, 30.25];

echo "Original prices: ";
print_r($prices);

// Use & to modify the original array
foreach ($prices as &$price) {
    $price = $price * 1.10;  // Add 10% tax
}
unset($price);  // Important! Unset reference after loop

echo "After 10% tax: ";
print_r($prices);

echo "\n=== Without Reference (No Modification) ===\n";
$numbers = [1, 2, 3, 4, 5];

echo "Before: ";
print_r($numbers);

// Without &, $num is a copy - original unchanged
foreach ($numbers as $num) {
    $num = $num * 2;  // Only modifies the copy
}

echo "After (unchanged): ";
print_r($numbers);

echo "\n=== Practical: Sanitize User Input ===\n";
$inputs = [" Hello ", "WORLD  ", " PHP "];

echo "Raw inputs:\n";
foreach ($inputs as $input) {
    echo "  '$input'\n";
}

// Clean up strings in place
foreach ($inputs as &$input) {
    $input = trim(strtolower($input));
}
unset($input);

echo "\nSanitized:\n";
foreach ($inputs as $input) {
    echo "  '$input'\n";
}

echo "\n=== Reference with Key-Value ===\n";
$products = [
    "apple" => ["price" => 1.50, "stock" => 100],
    "banana" => ["price" => 0.75, "stock" => 150],
    "orange" => ["price" => 2.00, "stock" => 80]
];

// Reduce all stock by 10
foreach ($products as $name => &$product) {
    $product['stock'] -= 10;
    echo "$name: {$product['stock']} remaining\n";
}
unset($product);

echo "\n=== Danger: Forgetting unset() ===\n";
$arr = [1, 2, 3];

foreach ($arr as &$val) {
    // $val is a reference
}
// $val still references $arr[2]!

// Without unset($val), this overwrites $arr[2]!
// $val = 999;  // Would make $arr = [1, 2, 999]

unset($val);  // Always do this!
echo "Array preserved: " . implode(", ", $arr) . "\n";
?>
