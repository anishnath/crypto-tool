<?php
// Basic substring extraction
$text = "Hello 世界 World";
echo "Original: " . $text . "\n";
echo "First 5 chars: " . mb_substr($text, 0, 5) . "\n";
echo "From position 6: " . mb_substr($text, 6) . "\n\n";

// Negative start position
$japanese = "こんにちは世界";
echo "Japanese: " . $japanese . "\n";
echo "Last 2 chars: " . mb_substr($japanese, -2) . "\n";
echo "Middle chars: " . mb_substr($japanese, 2, 3) . "\n\n";

// With emoji
$emoji = "🌟 Hello 👋 World 🌍";
echo "With emoji: " . $emoji . "\n";
echo "Extract emoji: " . mb_substr($emoji, 0, 1) . "\n";
?>