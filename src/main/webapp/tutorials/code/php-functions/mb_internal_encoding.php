<?php
// Get current encoding
$current = mb_internal_encoding();
echo "Current encoding: " . $current . "\n\n";

// Set to UTF-8
mb_internal_encoding('UTF-8');
echo "Set to UTF-8\n";
echo "New encoding: " . mb_internal_encoding() . "\n\n";

// Use with mb functions
$text = "Hello 世界";
echo "String length: " . mb_strlen($text) . "\n";
echo "Substring: " . mb_substr($text, 0, 5) . "\n\n";

// Reset to original
mb_internal_encoding($current);
echo "Reset to: " . mb_internal_encoding() . "\n";
?>