<?php
// Validate dates
var_dump(checkdate(12, 31, 2024)); // bool(true) - Valid
echo "\n";
var_dump(checkdate(2, 29, 2024));  // bool(true) - Leap year
echo "\n";
var_dump(checkdate(2, 29, 2023));  // bool(false) - Not leap year
echo "\n";
var_dump(checkdate(13, 1, 2024));  // bool(false) - Invalid month
?>
