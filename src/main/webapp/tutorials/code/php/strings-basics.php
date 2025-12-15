<?php
// String basics in PHP

// Single quotes - literal strings
$single = 'Hello, World!';
echo $single;
echo "\n";

// Double quotes - variables are parsed
$name = "John";
$double = "Hello, $name!";
echo $double;  // Output: Hello, John!
echo "\n";

// Concatenation with dot operator
$first = "Hello";
$last = "World";
$combined = $first . " " . $last;
echo $combined;
echo "\n";

// Heredoc syntax (like double quotes)
$text = <<<EOT
This is a multi-line
string using heredoc.
Variables like $name work here.
EOT;
echo $text;
