<?php
// Round up to integer
echo ceil(4.1);   // 5
echo ceil(4.9);   // 5
echo ceil(4.0);   // 4
echo "\n";

// Negative numbers
echo ceil(-4.1);  // -4
echo ceil(-4.9);  // -4
echo "\n";

// Practical: calculate pages needed
$items = 23;
$perPage = 5;
echo "Pages needed: " . ceil($items / $perPage);  // 5
?>
