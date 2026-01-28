<?php
// Convert to uppercase
$str = "Hello World";
echo strtoupper($str);  // "HELLO WORLD"
echo "\n";

// Useful for formatting
$code = "abc123";
echo strtoupper($code); // "ABC123"
echo "\n";

// ucfirst - capitalize first letter
echo ucfirst("hello");  // "Hello"
echo "\n";

// ucwords - capitalize each word
echo ucwords("hello world"); // "Hello World"
?>
