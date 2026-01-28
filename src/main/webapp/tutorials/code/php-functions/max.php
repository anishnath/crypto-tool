<?php
// Find maximum value
echo max(1, 5, 3);     // 5
echo max(10, 20, 15);  // 20
echo "\n";

// With array
$nums = [3, 7, 2, 9, 1];
echo max($nums);  // 9
echo "\n";

// Compare strings
echo max("apple", "banana", "cherry");  // "cherry"
echo "\n";

// Practical use
$scores = [85, 92, 78, 95, 88];
echo "Highest score: " . max($scores);  // 95
?>
