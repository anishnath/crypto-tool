<?php
// PHP preg_replace_callback() - Replace using callback

// Convert to uppercase
$text = "hello world";
$upper = preg_replace_callback(
    '/\b\w+\b/',
    fn($m) => strtoupper($m[0]),
    $text
);
echo "Uppercase: $upper\n";

// Double all numbers
$str = "Score: 10, Level: 5";
$doubled = preg_replace_callback(
    '/\d+/',
    fn($m) => $m[0] * 2,
    $str
);
echo "Doubled: $doubled\n";

// Format currency
$prices = "Items cost 1000 and 2500 dollars";
$formatted = preg_replace_callback(
    '/\d+/',
    fn($m) => '$' . number_format($m[0]),
    $prices
);
echo "Formatted: $formatted\n";

// Capitalize first letter of each word
$title = "the quick brown fox";
$result = preg_replace_callback(
    '/\b\w/',
    fn($m) => strtoupper($m[0]),
    $title
);
echo "Title Case: $result";
?>
