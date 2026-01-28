<?php
// PHP preg_quote() - Escape regex special characters

// User input with special chars
$userInput = "Price: $100 (USD)";
$escaped = preg_quote($userInput, '/');
echo "Original: $userInput\n";
echo "Escaped: $escaped\n\n";

// Safe search
$text = "The price is Price: $100 (USD) today";
$pattern = '/' . preg_quote($userInput, '/') . '/';
if (preg_match($pattern, $text)) {
    echo "Found match!\n\n";
}

// Characters that get escaped
$special = '. \\ + * ? [ ^ ] $ ( ) { } = ! < > | : - #';
echo "Special chars: $special\n";
echo "Escaped: " . preg_quote($special, '/') . "\n\n";

// With different delimiter
$path = "C:\\Users\\test";
$escapedPath = preg_quote($path, '#');
echo "Path escaped: $escapedPath";
?>
