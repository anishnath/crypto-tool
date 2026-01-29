<?php
// Basic uppercase conversion
$text = "hello world";
echo "Original: " . $text . "\n";
echo "Uppercase: " . mb_strtoupper($text) . "\n\n";

// International characters
$french = "café français";
echo "French: " . $french . "\n";
echo "Uppercase: " . mb_strtoupper($french, 'UTF-8') . "\n\n";

// Mixed languages
$mixed = "hello 世界 мира";
echo "Mixed: " . $mixed . "\n";
echo "Uppercase: " . mb_strtoupper($mixed, 'UTF-8') . "\n";
?>