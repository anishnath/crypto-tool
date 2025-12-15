<?php
// Array Functions - Adding and Removing

$fruits = ["apple", "banana"];

// Add to end
array_push($fruits, "cherry");
$fruits[] = "date";  // Alternative
print_r($fruits);
echo "\n";

// Add to beginning
array_unshift($fruits, "apricot");
print_r($fruits);
echo "\n";

// Remove from end
$last = array_pop($fruits);
echo "Removed: " . $last;
echo "\n";

// Remove from beginning
$first = array_shift($fruits);
echo "Removed: " . $first;
echo "\n";

// Remove specific element
unset($fruits[1]);
print_r($fruits);
echo "\n";

// Re-index array after unset
$fruits = array_values($fruits);
print_r($fruits);
