<?php
// strlen() - Get string length
// Returns the number of bytes in a string

// Basic example
$text = "Hello, World!";
echo "String: '$text'\n";
echo "Length: " . strlen($text) . "\n\n";

// Password validation example
$password = "secret";
echo "Password: '$password'\n";
echo "Length: " . strlen($password) . "\n";

if (strlen($password) < 8) {
    echo "Warning: Password should be at least 8 characters!\n\n";
}

// Empty vs whitespace
$empty = "";
$spaces = "   ";
echo "Empty string length: " . strlen($empty) . "\n";
echo "Spaces '   ' length: " . strlen($spaces) . "\n\n";

// Working with different strings
$strings = [
    "PHP",
    "Hello World",
    "12345",
    "Line1\nLine2"  // Newline counts as 1 character
];

echo "Various strings:\n";
foreach ($strings as $s) {
    $display = str_replace("\n", "\\n", $s);
    echo "  '$display' => " . strlen($s) . " bytes\n";
}
