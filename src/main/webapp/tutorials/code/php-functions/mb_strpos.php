<?php
// Basic search
$text = "Hello 世界 World";
echo "Text: " . $text . "\n";
echo "Position of '世': " . mb_strpos($text, '世') . "\n";
echo "Position of 'World': " . mb_strpos($text, 'World') . "\n\n";

// Case-sensitive search
$japanese = "こんにちは世界";
echo "Japanese: " . $japanese . "\n";
echo "Position of '世': " . mb_strpos($japanese, '世', 0, 'UTF-8') . "\n\n";

// Not found
$result = mb_strpos($text, 'xyz');
echo "Search 'xyz': " . ($result === false ? "Not found" : $result) . "\n";
?>