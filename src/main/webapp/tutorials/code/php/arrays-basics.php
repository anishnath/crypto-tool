<?php
// PHP Array Basics Demo
// 8gwifi.org/tutorials

echo "=== Creating Indexed Arrays ===\n";

// Short syntax (PHP 5.4+) - Recommended
$fruits = ["Apple", "Banana", "Cherry", "Date"];

// Traditional syntax
$colors = array("Red", "Green", "Blue");

echo "Fruits: ";
print_r($fruits);

echo "\n=== Accessing Array Elements ===\n";
echo "First fruit: " . $fruits[0] . "\n";
echo "Second fruit: " . $fruits[1] . "\n";
echo "Last fruit: " . $fruits[count($fruits) - 1] . "\n";

// Negative index (PHP 8.0+ allows with array functions)
echo "Last using end(): " . end($fruits) . "\n";

echo "\n=== Modifying Arrays ===\n";
$fruits[1] = "Blueberry";  // Replace element
echo "After changing index 1: ";
print_r($fruits);

$fruits[] = "Elderberry";  // Append element
echo "After appending: ";
print_r($fruits);

echo "\n=== Array Length ===\n";
echo "Number of fruits: " . count($fruits) . "\n";
echo "Using sizeof(): " . sizeof($fruits) . "\n";

echo "\n=== Checking if Array ===\n";
$notArray = "Hello";
echo "Is \$fruits an array? " . (is_array($fruits) ? "Yes" : "No") . "\n";
echo "Is \$notArray an array? " . (is_array($notArray) ? "Yes" : "No") . "\n";

echo "\n=== Empty Arrays ===\n";
$empty1 = [];
$empty2 = array();
echo "Empty array count: " . count($empty1) . "\n";
echo "Is empty? " . (empty($empty1) ? "Yes" : "No") . "\n";

echo "\n=== Quick Array Creation ===\n";
$numbers = range(1, 5);
echo "range(1, 5): ";
print_r($numbers);

$letters = range('a', 'e');
echo "range('a', 'e'): ";
print_r($letters);

$evens = range(2, 10, 2);
echo "range(2, 10, 2): ";
print_r($evens);
?>
