<?php
// Date parts as integers
$timestamp = strtotime('2025-12-25 14:30:00');

echo "Year: " . idate('Y', $timestamp) . "\n";
echo "Month: " . idate('m', $timestamp) . "\n";
echo "Day: " . idate('d', $timestamp) . "\n";
echo "Hour: " . idate('H', $timestamp) . "\n";
?>