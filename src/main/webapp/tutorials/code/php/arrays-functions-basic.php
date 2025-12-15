<?php
// PHP Array Functions I - Searching and Checking
// 8gwifi.org/tutorials

echo "=== Array Size Functions ===\n";
$fruits = ["Apple", "Banana", "Cherry", "Date", "Elderberry"];
$nested = ["a", ["b", "c"], "d"];

echo "count(\$fruits): " . count($fruits) . "\n";
echo "sizeof(\$fruits): " . sizeof($fruits) . "\n";  // Alias
echo "count(\$nested): " . count($nested) . "\n";    // Only top level
echo "count(\$nested, COUNT_RECURSIVE): " . count($nested, COUNT_RECURSIVE) . "\n";

echo "\n=== Checking for Values ===\n";
$colors = ["red", "green", "blue", "Red"];

echo "in_array('green', \$colors): " . (in_array("green", $colors) ? "true" : "false") . "\n";
echo "in_array('yellow', \$colors): " . (in_array("yellow", $colors) ? "true" : "false") . "\n";
echo "in_array('Red', \$colors): " . (in_array("Red", $colors) ? "true" : "false") . "\n";

// Strict comparison (type-sensitive)
$numbers = [1, 2, "3", 4];
echo "\nin_array(3, \$numbers): " . (in_array(3, $numbers) ? "true" : "false") . "\n";
echo "in_array(3, \$numbers, true): " . (in_array(3, $numbers, true) ? "true" : "false") . "\n";

echo "\n=== Finding Array Keys ===\n";
$fruits = ["apple", "banana", "cherry", "banana"];

echo "array_search('banana', \$fruits): " . array_search("banana", $fruits) . "\n";  // First match
echo "array_search('grape', \$fruits): " . var_export(array_search("grape", $fruits), true) . "\n";

echo "\n=== Checking for Keys ===\n";
$person = ["name" => "John", "age" => 30, "city" => null];

echo "array_key_exists('name', \$person): " . (array_key_exists("name", $person) ? "true" : "false") . "\n";
echo "array_key_exists('email', \$person): " . (array_key_exists("email", $person) ? "true" : "false") . "\n";
echo "array_key_exists('city', \$person): " . (array_key_exists("city", $person) ? "true" : "false") . "\n";

// isset vs array_key_exists
echo "\nisset(\$person['city']): " . (isset($person['city']) ? "true" : "false") . "\n";
echo "array_key_exists('city', \$person): " . (array_key_exists("city", $person) ? "true" : "false") . "\n";

echo "\n=== Getting Keys and Values ===\n";
$product = ["id" => 101, "name" => "Laptop", "price" => 999.99];

echo "array_keys(\$product): ";
print_r(array_keys($product));

echo "array_values(\$product): ";
print_r(array_values($product));

echo "\n=== Getting Specific Keys ===\n";
$scores = ["Alice" => 95, "Bob" => 88, "Carol" => 95, "David" => 72];

echo "Keys with value 95: ";
print_r(array_keys($scores, 95));

echo "\n=== First and Last Elements ===\n";
$items = ["first", "second", "third", "last"];

echo "reset(\$items): " . reset($items) . "\n";  // First element
echo "end(\$items): " . end($items) . "\n";      // Last element
echo "current(\$items): " . current($items) . "\n";  // Current pointer position

// Get first/last key (PHP 7.3+)
echo "array_key_first(\$items): " . array_key_first($items) . "\n";
echo "array_key_last(\$items): " . array_key_last($items) . "\n";
?>
