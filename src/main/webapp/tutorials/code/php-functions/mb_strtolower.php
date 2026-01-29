<?php
// Basic lowercase conversion
$text = "HELLO WORLD";
echo "Original: " . $text . "\n";
echo "Lowercase: " . mb_strtolower($text) . "\n\n";

// International characters
$german = "ÄÖÜSS GRÜßEN";
echo "German: " . $german . "\n";
echo "Lowercase: " . mb_strtolower($german, 'UTF-8') . "\n\n";

// Mixed languages
$mixed = "HELLO 世界 МИРА";
echo "Mixed: " . $mixed . "\n";
echo "Lowercase: " . mb_strtolower($mixed, 'UTF-8') . "\n";
?>