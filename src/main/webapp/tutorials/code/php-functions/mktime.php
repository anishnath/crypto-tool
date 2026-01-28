<?php
// Create timestamp from components
// mktime(hour, minute, second, month, day, year)
$ts = mktime(14, 30, 0, 1, 28, 2025);
echo date("Y-m-d H:i:s", $ts);
echo "\n";

// First day of month
$firstDay = mktime(0, 0, 0, date("m"), 1, date("Y"));
echo "First day: " . date("Y-m-d", $firstDay);
echo "\n";

// Last day of month
$lastDay = mktime(0, 0, 0, date("m") + 1, 0, date("Y"));
echo "Last day: " . date("Y-m-d", $lastDay);
?>
