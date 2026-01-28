<?php
// Basic substr - extract part of string
$str = "Hello World";
echo substr($str, 0, 5);   // "Hello"
echo "\n";
echo substr($str, 6);      // "World"
echo "\n";

// Negative start - from end
echo substr($str, -5);     // "World"
echo "\n";

// Negative length - omit from end
echo substr($str, 0, -6);  // "Hello"
?>
