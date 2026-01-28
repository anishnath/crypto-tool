<?php
// Round down to integer
echo floor(4.9);   // 4
echo floor(4.1);   // 4
echo floor(4.0);   // 4
echo "\n";

// Negative numbers
echo floor(-4.1);  // -5
echo floor(-4.9);  // -5
echo "\n";

// Practical: pagination
$total = 57;
$perPage = 10;
$pages = ceil($total / $perPage);  // 6 pages
echo "Total pages: $pages";
?>
