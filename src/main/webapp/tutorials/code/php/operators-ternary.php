<?php
// Ternary and Null Coalescing Operators

// Ternary operator: condition ? true_value : false_value
$age = 20;
$status = ($age >= 18) ? "Adult" : "Minor";
echo "Status: " . $status;  // "Adult"
echo "\n";

// Nested ternary (not recommended)
$score = 85;
$grade = ($score >= 90) ? "A" : (($score >= 80) ? "B" : "C");
echo "Grade: " . $grade;  // "B"
echo "\n";

// Null coalescing operator (PHP 7+)
// Returns first operand if it exists and is not null, otherwise second
$username = null;
$display = $username ?? "Guest";
echo "User: " . $display;  // "Guest"
echo "\n";

// Chain null coalescing
$name = null;
$default = "Anonymous";
$result = $name ?? $default ?? "Unknown";
echo "Result: " . $result;  // "Anonymous"
echo "\n";

// Null coalescing assignment (PHP 7.4+)
$count = null;
$count ??= 0;  // Same as: $count = $count ?? 0
echo "Count: " . $count;  // 0
