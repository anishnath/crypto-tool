<?php
// Format string with placeholders
$name = "John";
$age = 25;
echo sprintf("Name: %s, Age: %d", $name, $age);
echo "\n";

// Number formatting
$price = 19.99;
echo sprintf("Price: $%.2f", $price);  // "Price: $19.99"
echo "\n";

// Padding
echo sprintf("%05d", 42);    // "00042"
echo "\n";
echo sprintf("%-10s", "Hi"); // "Hi        " (left-aligned)
?>
