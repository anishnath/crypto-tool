<?php
// Current Unix timestamp
echo time();  // e.g., 1706454123
echo "\n";

// Calculate future/past times
$now = time();
$tomorrow = $now + (24 * 60 * 60);
$yesterday = $now - (24 * 60 * 60);

echo "Tomorrow: " . date("Y-m-d", $tomorrow);
echo "\n";
echo "Yesterday: " . date("Y-m-d", $yesterday);
echo "\n";

// Time difference
$start = time();
// ... some operation ...
$elapsed = time() - $start;
echo "Elapsed: {$elapsed}s";
?>
