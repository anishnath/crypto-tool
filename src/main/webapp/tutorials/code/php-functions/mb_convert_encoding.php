<?php
// UTF-8 to ISO-8859-1
$utf8_text = "Café français";
echo "Original (UTF-8): " . $utf8_text . "\n";
$iso = mb_convert_encoding($utf8_text, 'ISO-8859-1', 'UTF-8');
echo "Converted to ISO-8859-1\n\n";

// Auto-detect source encoding
$text = "Hello 世界";
$converted = mb_convert_encoding($text, 'UTF-8', 'auto');
echo "Auto-detected and converted: " . $converted . "\n\n";

// Multiple encodings
$japanese = "こんにちは";
echo "Japanese (UTF-8): " . $japanese . "\n";
$sjis = mb_convert_encoding($japanese, 'SJIS', 'UTF-8');
echo "Converted to SJIS\n";
?>