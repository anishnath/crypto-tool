<?php
// Basic usage - UTF-8 string length
$text = "Hello 世界";
echo "String: " . $text . "\n";
echo "mb_strlen: " . mb_strlen($text) . "\n";
echo "strlen: " . strlen($text) . " (incorrect for multibyte)\n\n";

// Different encodings
$japanese = "こんにちは";
echo "Japanese: " . $japanese . "\n";
echo "Character count: " . mb_strlen($japanese, 'UTF-8') . "\n\n";

// Emoji handling
$emoji = "Hello 👋 World 🌍";
echo "With emoji: " . $emoji . "\n";
echo "Character count: " . mb_strlen($emoji, 'UTF-8') . "\n";
?>