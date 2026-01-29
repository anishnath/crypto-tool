<?php
// Sort numbers in reverse
$numbers = [3, 1, 4, 1, 5, 9, 2, 6];
echo "Original: " . implode(", ", $numbers) . "\n";

rsort($numbers);
echo "After rsort(): " . implode(", ", $numbers) . "\n";

// Sort strings in reverse
$fruits = ["apple", "cherry", "banana", "date"];
rsort($fruits);
echo "Fruits (reverse): " . implode(", ", $fruits) . "\n";

// Numeric sort
$mixed = ["10", "2", "30", "4"];
rsort($mixed, SORT_NUMERIC);
echo "Numeric reverse: " . implode(", ", $mixed);
?>