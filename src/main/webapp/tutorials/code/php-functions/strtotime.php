<?php
// Parse date string to timestamp
echo strtotime("2025-01-28");
echo "\n";

// Relative dates
echo date("Y-m-d", strtotime("tomorrow"));
echo "\n";
echo date("Y-m-d", strtotime("next Monday"));
echo "\n";
echo date("Y-m-d", strtotime("+1 week"));
echo "\n";
echo date("Y-m-d", strtotime("-3 days"));
echo "\n";

// Practical: expiration date
$expires = strtotime("+30 days");
echo "Expires: " . date("Y-m-d", $expires);
?>
