<?php
// Detect UTF-8
$utf8_text = "Hello 世界";
$encoding = mb_detect_encoding($utf8_text);
echo "Text: " . $utf8_text . "\n";
echo "Detected encoding: " . $encoding . "\n\n";

// Detect with specific encodings
$japanese = "こんにちは";
$detected = mb_detect_encoding($japanese, ['UTF-8', 'SJIS', 'EUC-JP']);
echo "Japanese text\n";
echo "Detected: " . $detected . "\n\n";

// Strict mode
$text = "Café";
$strict = mb_detect_encoding($text, 'UTF-8', true);
echo "Strict detection: " . ($strict ? $strict : "Failed") . "\n";
?>