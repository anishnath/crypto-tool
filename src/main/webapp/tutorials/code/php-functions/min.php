<?php
// Find minimum value
echo min(1, 5, 3);     // 1
echo min(10, 20, 15);  // 10
echo "\n";

// With array
$nums = [3, 7, 2, 9, 1];
echo min($nums);  // 1
echo "\n";

// Practical: price comparison
$prices = [29.99, 24.99, 34.99, 19.99];
echo "Lowest price: $" . min($prices);  // $19.99
echo "\n";

// Limit value to range
$value = 150;
$limited = max(0, min(100, $value));  // Clamp 0-100
echo "Clamped: $limited";  // 100
?>
