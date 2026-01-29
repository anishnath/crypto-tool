<?php
// Remove elements from array
$fruits = ["apple", "banana", "cherry", "date", "elderberry"];
$removed = array_splice($fruits, 2, 2);
echo "Removed: " . implode(", ", $removed) . "\n";
echo "Remaining: " . implode(", ", $fruits) . "\n";

// Replace elements
$colors = ["red", "green", "blue"];
array_splice($colors, 1, 1, ["yellow", "orange"]);
echo "Colors: " . implode(", ", $colors) . "\n";

// Insert without removing
$numbers = [1, 2, 5, 6];
array_splice($numbers, 2, 0, [3, 4]);
echo "Numbers: " . implode(", ", $numbers);
?>