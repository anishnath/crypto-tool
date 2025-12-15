<?php
// String functions

$text = "  Hello, PHP World!  ";

// Length
echo "Length: " . strlen($text);
echo "\n";

// Trim whitespace
echo "Trimmed: '" . trim($text) . "'";
echo "\n";

// Uppercase/Lowercase
echo "Upper: " . strtoupper($text);
echo "\n";
echo "Lower: " . strtolower($text);
echo "\n";

// Substring
$str = "Hello World";
echo "Substring: " . substr($str, 0, 5);  // "Hello"
echo "\n";

// Replace
echo "Replace: " . str_replace("World", "PHP", $str);
echo "\n";

// Position
echo "Position of 'World': " . strpos($str, "World");
echo "\n";

// Split string
$words = explode(" ", $str);
echo "Words: ";
print_r($words);
