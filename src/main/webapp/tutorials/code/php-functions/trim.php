<?php
// Remove whitespace from both ends
$str = "  Hello World  ";
echo "[" . trim($str) . "]";  // "[Hello World]"
echo "\n";

// ltrim - left only
echo "[" . ltrim($str) . "]"; // "[Hello World  ]"
echo "\n";

// rtrim - right only
echo "[" . rtrim($str) . "]"; // "[  Hello World]"
echo "\n";

// Trim specific characters
$str = "###Hello###";
echo trim($str, "#");         // "Hello"
?>
