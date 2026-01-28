<?php
// Get absolute value
echo abs(-5);    // 5
echo abs(5);     // 5
echo abs(-3.14); // 3.14
echo "\n";

// Practical: distance between points
$point1 = 10;
$point2 = 25;
$distance = abs($point1 - $point2);
echo "Distance: $distance\n";  // 15

// Difference calculation
$expected = 100;
$actual = 95;
$diff = abs($expected - $actual);
echo "Difference: $diff";  // 5
?>
