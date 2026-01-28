<?php
// GMT timestamp
$timestamp = gmmktime(12, 0, 0, 10, 3, 1975);
echo $timestamp . "\n";
echo date("Y-m-d H:i:s", $timestamp) . " (Local)\n";
echo gmdate("Y-m-d H:i:s", $timestamp) . " (GMT)\n";
?>