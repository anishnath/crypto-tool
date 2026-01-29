<?php
// Split into characters
$text = "Hello世界";
echo "Original: " . $text . "\n";
$chars = mb_str_split($text);
echo "Characters: ";
print_r($chars);
echo "\n";

// Split into chunks
$japanese = "こんにちは世界";
echo "Japanese: " . $japanese . "\n";
$chunks = mb_str_split($japanese, 2, 'UTF-8');
echo "2-char chunks: ";
print_r($chunks);
echo "\n";

// With emoji
$emoji = "👋🌍🎉";
$emoji_array = mb_str_split($emoji, 1, 'UTF-8');
echo "Emoji split: ";
print_r($emoji_array);
?>