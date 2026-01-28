<?php
// Find position of substring
$str = "Hello World";
echo strpos($str, "World");  // 6
echo "\n";

// Not found returns false
$pos = strpos($str, "PHP");
var_dump($pos);  // bool(false)

// Case-sensitive
echo strpos($str, "world");  // false (not found)
echo "\n";

// Use stripos for case-insensitive
echo stripos($str, "world"); // 6
?>
